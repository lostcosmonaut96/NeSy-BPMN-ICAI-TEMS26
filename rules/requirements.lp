% =====================================================================
%  Double Materiality Assessment - requirements knowledge base
%  Answer Set Programming (ASP) encoding, evaluated with clingo.
%
%  This file is the machine-checkable form of the 33 requirements listed in
%  requirements.md. It is the artefact the symbolic layer consumes to decide
%  phase gates and to parameterise the degree-of-fit.
%
%  SCHEMA
%    requirement(R).            R is a requirement of the reference model
%    phase(R, P).               R belongs to phase P (p1..p7); exactly one
%    predicate(R, Pr).          R is checked through the atomic predicate Pr
%    gate(R, G).                G = presence | content
%    required(P, Pr).           Pr must be evidenced for phase P  [blocking]
%
%  EVIDENCE (asserted at run time, one atom per positive verifier judgement)
%    holds(P, Pr).              in phase P the report evidences predicate Pr
%
%  Evidence is phase-scoped on purpose: the same predicate required by two
%  phases is not satisfied across them - it must be evidenced in each.
% =====================================================================

% ---------------------------------------------------------------- phases
phase_id(p1;p2;p3;p4;p5;p6;p7).

% ---------------------------------------------- p1 : Governance mandate
requirement(req_p1_01).
phase(req_p1_01, p1).
predicate(req_p1_01, administrative_body_oversees_sustainability).
gate(req_p1_01, content).
required(p1, administrative_body_oversees_sustainability).

requirement(req_p1_02).
phase(req_p1_02, p1).
predicate(req_p1_02, reporting_perimeter_aligned_with_financial_statements).
gate(req_p1_02, content).
required(p1, reporting_perimeter_aligned_with_financial_statements).

requirement(req_p1_03).
phase(req_p1_03, p1).
predicate(req_p1_03, responsibility_for_report_preparation).
gate(req_p1_03, presence).
required(p1, responsibility_for_report_preparation).

% ---------------------------------------------- p2 : Stakeholder engagement
requirement(req_p2_01).
phase(req_p2_01, p2).
predicate(req_p2_01, consults_stakeholders).
gate(req_p2_01, content).
required(p2, consults_stakeholders).

requirement(req_p2_02).
phase(req_p2_02, p2).
predicate(req_p2_02, identifies_and_classifies_stakeholders).
gate(req_p2_02, content).
required(p2, identifies_and_classifies_stakeholders).

requirement(req_p2_03).
phase(req_p2_03, p2).
predicate(req_p2_03, integrates_stakeholder_views_in_materiality).
gate(req_p2_03, content).
required(p2, integrates_stakeholder_views_in_materiality).

requirement(req_p2_04).
phase(req_p2_04, p2).
predicate(req_p2_04, stakeholder_views_inform_strategy_and_governance).
gate(req_p2_04, content).
required(p2, stakeholder_views_inform_strategy_and_governance).

% ---------------------------------------------- p3 : Impact materiality (inside-out)
requirement(req_p3_01).
phase(req_p3_01, p3).
predicate(req_p3_01, applies_impact_materiality_thresholds).
gate(req_p3_01, content).
required(p3, applies_impact_materiality_thresholds).

requirement(req_p3_02).
phase(req_p3_02, p3).
predicate(req_p3_02, covers_value_chain_in_impact_assessment).
gate(req_p3_02, content).
required(p3, covers_value_chain_in_impact_assessment).

requirement(req_p3_03).
phase(req_p3_03, p3).
predicate(req_p3_03, describes_impact_materiality_process).
gate(req_p3_03, content).
required(p3, describes_impact_materiality_process).

requirement(req_p3_04).
phase(req_p3_04, p3).
predicate(req_p3_04, discloses_material_impacts_outcome).
gate(req_p3_04, content).
required(p3, discloses_material_impacts_outcome).

requirement(req_p3_05).
phase(req_p3_05, p3).
predicate(req_p3_05, scores_impact_severity_and_likelihood).
gate(req_p3_05, content).
required(p3, scores_impact_severity_and_likelihood).

% ---------------------------------------------- p4 : Financial materiality (outside-in)
requirement(req_p4_01).
phase(req_p4_01, p4).
predicate(req_p4_01, assesses_financial_effects_over_time_horizons).
gate(req_p4_01, content).
required(p4, assesses_financial_effects_over_time_horizons).

requirement(req_p4_02).
phase(req_p4_02, p4).
predicate(req_p4_02, defines_assessment_time_horizons).
gate(req_p4_02, content).
required(p4, defines_assessment_time_horizons).

requirement(req_p4_03).
phase(req_p4_03, p4).
predicate(req_p4_03, identifies_sustainability_risks_and_opportunities).
gate(req_p4_03, content).
required(p4, identifies_sustainability_risks_and_opportunities).

requirement(req_p4_04).
phase(req_p4_04, p4).
predicate(req_p4_04, scores_financial_materiality_by_likelihood_and_magnitude).
gate(req_p4_04, content).
required(p4, scores_financial_materiality_by_likelihood_and_magnitude).

% ---------------------------------------------- p5 : Indicator collection
requirement(req_p5_01).
phase(req_p5_01, p5).
predicate(req_p5_01, collects_and_validates_indicator_data).
gate(req_p5_01, content).
required(p5, collects_and_validates_indicator_data).

requirement(req_p5_02).
phase(req_p5_02, p5).
predicate(req_p5_02, disaggregates_reported_information).
gate(req_p5_02, content).
required(p5, disaggregates_reported_information).

requirement(req_p5_03).
phase(req_p5_03, p5).
predicate(req_p5_03, discloses_comparative_and_restated_data).
gate(req_p5_03, content).
required(p5, discloses_comparative_and_restated_data).

requirement(req_p5_04).
phase(req_p5_04, p5).
predicate(req_p5_04, discloses_material_topic_metrics).
gate(req_p5_04, content).
required(p5, discloses_material_topic_metrics).

requirement(req_p5_05).
phase(req_p5_05, p5).
predicate(req_p5_05, documents_metric_methodology_and_uncertainty).
gate(req_p5_05, content).
required(p5, documents_metric_methodology_and_uncertainty).

requirement(req_p5_06).
phase(req_p5_06, p5).
predicate(req_p5_06, maps_datapoints_to_material_topics).
gate(req_p5_06, content).
required(p5, maps_datapoints_to_material_topics).

% ---------------------------------------------- p6 : External assurance
requirement(req_p6_01).
phase(req_p6_01, p6).
predicate(req_p6_01, assurance_provider_is_independent).
gate(req_p6_01, content).
required(p6, assurance_provider_is_independent).

requirement(req_p6_02).
phase(req_p6_02, p6).
predicate(req_p6_02, describes_assurance_approach).
gate(req_p6_02, content).
required(p6, describes_assurance_approach).

requirement(req_p6_03).
phase(req_p6_03, p6).
predicate(req_p6_03, discloses_assurance_scope_and_level).
gate(req_p6_03, content).
required(p6, discloses_assurance_scope_and_level).

requirement(req_p6_04).
phase(req_p6_04, p6).
predicate(req_p6_04, documents_assurance_engagement).
gate(req_p6_04, content).
required(p6, documents_assurance_engagement).

requirement(req_p6_05).
phase(req_p6_05, p6).
predicate(req_p6_05, has_external_assurance).
gate(req_p6_05, presence).
required(p6, has_external_assurance).

% ---------------------------------------------- p7 : Final disclosure
requirement(req_p7_01).
phase(req_p7_01, p7).
predicate(req_p7_01, applies_digital_tagging).
gate(req_p7_01, content).
required(p7, applies_digital_tagging).

requirement(req_p7_02).
phase(req_p7_02, p7).
predicate(req_p7_02, approved_and_assured_disclosure).
gate(req_p7_02, presence).
required(p7, approved_and_assured_disclosure).

requirement(req_p7_03).
phase(req_p7_03, p7).
predicate(req_p7_03, links_to_financial_statements).
gate(req_p7_03, content).
required(p7, links_to_financial_statements).

requirement(req_p7_04).
phase(req_p7_04, p7).
predicate(req_p7_04, published_in_management_report).
gate(req_p7_04, presence).
required(p7, published_in_management_report).

requirement(req_p7_05).
phase(req_p7_05, p7).
predicate(req_p7_05, states_basis_for_preparation).
gate(req_p7_05, content).
required(p7, states_basis_for_preparation).

requirement(req_p7_06).
phase(req_p7_06, p7).
predicate(req_p7_06, structures_report_contents).
gate(req_p7_06, content).
required(p7, structures_report_contents).

% =====================================================================
%  GATE SEMANTICS
%  A phase is defined if it carries at least one requirement. It fails if
%  any required predicate is not evidenced in that phase, and passes if it
%  is defined and does not fail (strict reading, Eq. 1 of the paper).
% =====================================================================
phase_defined(P) :- required(P, _).
fails(P)         :- required(P, Pr), not holds(P, Pr).
passes(P)        :- phase_defined(P), not fails(P).

% Unmet requirements are enumerated, not just counted: every failure is
% reported as an itemised gap, which is what makes a verdict actionable.
gap(P, Pr) :- required(P, Pr), not holds(P, Pr).

% =====================================================================
%  DEGREE-OF-FIT (graded reading, Eq. 2 of the paper)
%  fit(P) = n_evidenced(P) / n_required(P), computed from these counts.
% =====================================================================
n_required(P, N)  :- phase_defined(P), N = #count{ Pr : required(P, Pr) }.
n_evidenced(P, N) :- phase_defined(P), N = #count{ Pr : required(P, Pr), holds(P, Pr) }.

#show passes/1.
#show fails/1.
#show gap/2.
#show n_required/2.
#show n_evidenced/2.
