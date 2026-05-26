# Planning Quality Policy
MODE: planning_quality_policy

LOAD_POLICY:
- must_read_when := ready_for_workflow|approval_request|quality_review|question_policy
- route := Planning mode/Planning.md

TARGET:
- inherit := Planning mode/Planning.md#LANGUAGE_POLICY
PURPOSE:
- plan_quality_gate
- review_control
RULES:
- blocker_questions.count = 0 before ready_for_workflow
- decision_source_separation := user_decisions != research_suggestions
- artifact_value_format := concise_fragments
- MVP.scope <= single_vertical_slice_start
- current_plan.implementable_without_unplanned_dependencies := true
- suggestions_with_unplanned_dependencies cannot_modify current_requirements
- baseline_ready := plan.coherent AND workflow.coherent AND user_approved
- mutable_until := freeze_scope OR begin_implementation
- scan_lenses := product_fit|UX_conversion|IA|domain_model|permission_model|integration_boundary|scalability|observability|testability|implementation_sequence
- idea_schema := improvement|technical_rationale|dependency_state|required_prerequisites|blocking_effect|safe_route|affected_artifact|implementation_impact|decision_prompt
- suggestion_count := 3..5
- rank_by := leverage|risk_reduction|implementation_impact
- unplanned_dependency.safe_route != current_requirement
- banned_closure := terminal_handoff|motivational_closure
- ask_one_blocker_question_at_time
- group_non_blocking_suggestions
- too_many_questions_message := "Prioritize only decisions required for current plan{n}/plan.md and workflow.md."
OUTPUT:
- quality_gates
- post_baseline_ideas
- question_policy
