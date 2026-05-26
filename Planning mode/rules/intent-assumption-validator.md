# Intent Assumption Validator
MODE: planning_intent_validation

LOAD_POLICY:
- must_read_when := goal_drift|assumption_change|requirement_change|suggestion_review
- route := Planning mode/Planning.md

TARGET:
- inherit := Planning mode/Planning.md#LANGUAGE_POLICY
PURPOSE:
- goal_alignment
- assumption_control
- suggestion_classification
RULES:
- latest_confirmed_user_goal := primary target
- artifact_delta must_support latest_confirmed_user_goal
- goal_drift -> stop_and_restate_tradeoff
- hidden_assumption := denied
- assumption_source := user_statement|research|agent_inference|domain_pattern
- agent_inference.requires_label := true
- assumption_impact := low|medium|high
- high_impact_assumption -> blocker_question
- medium_impact_assumption -> open_questions
- low_impact_assumption -> assumptions
- assumption_to_requirement requires user_explicit_approval
- suggestion_type := requirement_patch|future_dependency|optimization|risk_warning|research_needed|architecture_note
- future_dependency cannot_modify MVP_scope|current_requirements
- optimization cannot_block workflow_ready
- requirement_patch requires current_requirement = true
- risk_warning -> dependency_risk_register
- research_needed -> research_notes|open_questions
OUTPUT_TO_PLAN:
- assumptions
- open_questions
- research_notes
- dependency_risk_register
- suggestion_queue
