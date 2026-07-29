# Workflow — pseudocode

This document specifies the procedure. It is written so
that the measurement can be reproduced from the description alone: every step is
either deterministic and inspectable, or is the single narrow neural judgement the
design deliberately isolates.

**Notation.** `R` is the requirements knowledge base (33 entries, `rules/requirements.lp`);
`R_i ⊂ R` are the requirements carried by phase `P_i`, `i = 1…7`; `D` is a report;
`M` is the panel of six verifiers.

---

## Stage 0 — Symbolic preparation (once, independent of any report)

```
INPUT   requirements knowledge base R
OUTPUT  grounded ASP program; the required/2 relation

for each requirement r in R:
    assert  requirement(r), phase(r, P), predicate(r, Pr), gate(r, G)
    if G in {presence, content}:
        assert required(P, Pr)              # blocking: enters the phase gate

check    TOTALITY     every r maps to exactly one phase          # φ is a function
check    SURJECTIVITY every phase P_1…P_7 carries at least one r  # no empty phase
abort    if either check fails                                    # the rule base is rejected
```

The two checks are mechanical and run before any report is scored. They are what
makes the mapping requirement → phase auditable rather than asserted.

---

## Stage 1 — Report preprocessing (deterministic)

A sustainability statement is a long document of which only a part is evidence of
the assessment *process*. Preprocessing is therefore a reduction, not merely a split.

```
INPUT   report D (PDF)
OUTPUT  ordered list W of windows, each carrying its page and section label

pages ← extract_text_per_page(D)                    # text layer only
if total_extracted_text(pages) is negligible:
    mark D NOT ASSESSABLE and stop                  # scanned / image-only PDF

sections ← section_map(D)                           # from the document outline:
                                                    # page → nearest preceding heading
W ← []
for (page, text) in pages:
    text ← normalise_whitespace(text)
    if length(text) < MIN_PAGE_CHARS:               # covers, dividers, blank pages
        continue                                    # carry no process evidence
    for chunk in sliding_window(text, size = WIN, overlap = OV):
        if length(chunk) ≥ MIN_CHUNK:
            W.append( Window(text = chunk,
                             page = page,
                             section = sections[page]) )   # section-aware
return W
```

*Configuration used:* `WIN = 2400` characters with `OV = 400` overlap. The overlap
exists so that a statement straddling a boundary is not destroyed by the split.
Windows keep their page and section label so that every later judgement remains
locatable in the source document, and so that retrieval can use the section
heading as additional context.

**Exclusion rule.** A report whose text layer yields fewer than a minimum number of
windows is reported as *not assessable* and is excluded from the aggregate results,
rather than being scored as zero: an absent text layer is a property of the file,
not of the undertaking's disclosure. The exclusion is decided on this technical
criterion alone, never on the score obtained.

---

## Stage 2 — Candidate retrieval (deterministic, per requirement)

The model is never shown the whole report. For each requirement it is shown only
the passages that could plausibly bear on it.

```
INPUT   windows W, requirement r
OUTPUT  the k passages most likely to evidence r

q ← query_text(r)                                   # predicate + object, in words
e_q ← embed(q);  e_W ← embed(section ⊕ text for each window)   # cached per report
sim_dense[j]  ← cosine(e_q, e_W[j])
sim_lexical[j]← term_overlap(keywords(r), W[j])     # exact-term fallback signal
score[j]      ← sim_dense[j] + β · sim_lexical[j]   # hybrid
return top_k(score, k)
```

*Configuration used:* multilingual embeddings, hybrid dense + lexical scoring,
`k = 5` candidate passages per requirement, identical for every verifier.

> This retrieval selects *passages of the report to submit for judgement*. It does
> not retrieve rules: the knowledge base is fixed, explicit and read in full.

---

## Stage 3 — Grounding: the one neural judgement

```
INPUT   requirement r, its k candidate passages, verifier m
OUTPUT  holds(P, Pr) ∈ {0,1} with a verbatim span

holds ← 0;  span ← ""
for each candidate passage w in top_k(r):
    answer ← m( SYSTEM_PROMPT, user_message(r, w) )      # identical prompt for all m
    parse   answer as {holds, span, confidence, rationale}

    if answer.holds = 1:
        if answer.span does NOT occur verbatim in w.text:
            answer.holds ← 0                              # unsupported claim, demoted
    if answer.holds = 1 and (holds = 0 or answer.confidence > best_confidence):
        holds ← 1;  span ← answer.span;  page ← w.page

assert holds(P_of(r), predicate_of(r))  iff  holds = 1
record  (verifier, requirement, report, holds, span, page, confidence, rationale)
```

A requirement is evidenced if **any** of its candidate passages evidences it
(disjunction over passages); a positive verdict without a locatable span is not
counted. Every stored judgement traces back to the report text that produced it.

---

## Stage 4 — Symbolic evaluation and degree-of-fit

The verdicts are combined symbolically. Nothing here is learned or estimated.

```
INPUT   the holds/2 atoms produced by one verifier for one report
OUTPUT  per-phase gate, per-phase degree-of-fit, itemised gaps

# strict gate — a phase passes only if it carries no unmet requirement
passes(P)  ⟺  ∀ r ∈ R_P : holds(P, predicate(r)) = 1
gap(P, Pr) ⟸  required(P, Pr) ∧ ¬holds(P, Pr)          # enumerated, not just counted

# graded reading of the same evidence
fit(P_i)   =  |{ r ∈ R_i : holds(r) = 1 }| / |R_i|
fit(D)     =  (1/7) · Σ_{i=1..7} fit(P_i)               # phases weighted equally
```

The binary gate answers *is this phase complete?*; the degree-of-fit answers *how
far along is it?* and, together with `gap/2`, converts a negative verdict into an
itemised list of what is missing.

---

## Stage 5 — Panel aggregation and reliability

The choice of verifier is an implementation detail, not a finding. The panel is
therefore treated as a set of **equally admissible raters** of the same reference
model: no model is designated as ground truth, none is weighted above another, and
no model's output is calibrated against another's.

```
INPUT   holds atoms from all six verifiers m ∈ M, over all reports
OUTPUT  consensus scores + agreement statistics

# 1. Consensus by unweighted majority — every verifier has one vote
for each (report D, requirement r):
    holds_consensus(D, r) ← 1  iff  |{ m ∈ M : holds_m(D, r) = 1 }| > |M| / 2
fit_consensus(P_i), fit_consensus(D) ← Stage 4 applied to holds_consensus

# 2. Agreement between verifiers, on the unit of judgement
α ← krippendorff_alpha( matrix[ m ][ (D, r) ] = holds_m(D, r),
                        level = nominal )     # chance-corrected inter-rater reliability

# 3. What is claimed as a result is what is invariant across the panel
for each verifier m (and for the consensus):
    profile[m] ← ( fit_m(P_1), …, fit_m(P_7) )
report  the ORDERING of phases within each profile, and whether the partition
        into well-evidenced and weakly-evidenced phases is the same for all m
report  the rank correlation between verifiers over reports
report  absolute levels ONLY together with the verifier that produced them
```

**Why the aggregation is framed this way.** Verifiers differ in strictness: over the
same corpus and the same rule base, a more permissive model places every report
higher than a stricter one does. An absolute degree-of-fit is therefore meaningful
only with its verifier disclosed, and is comparable only within one verifier. What
*is* stable — and what the method reports as its result — is the **structure of the
diagnosis**: which phases of the process a corpus evidences and which it does not.
That partition is reproduced by every verifier and survives majority-vote consensus,
which is precisely the property a validation instrument must have if it is to be
read as a statement about the reference model rather than about the model that
happened to run it. Inter-rater agreement is reported as a first-class result, not
as a footnote, and the consensus is an unweighted majority so that the conclusion
does not depend on the choice of any single verifier.

---

## Stage 6 — Outputs

```
per judgement   verifier, report, requirement, holds, verbatim span, page, confidence
per report      fit(P_1..P_7), fit(D), gates passed, itemised gaps
per verifier    phase profile, report ranking
per panel       consensus fit, α, cross-verifier phase partition and rank correlation
```

Every number reported at panel level can be traced down to a stored judgement, and
every affirmative judgement to a quoted passage of the report that produced it.
