# Circumstance Branching Rule
MODE: planning_circumstance_analysis

LOAD_POLICY:
- must_read_when := conditional_flow|optional_registration|approval_gate|guest_path|post_submit_creation|alternate_circumstance
- route := ../Planning.md

TARGET:
- inherit := ../Planning.md#LANGUAGE_POLICY
PURPOSE:
- circumstance_scan
- alternate_path_analysis
- gated_flow_validation
RULES:
- circumstance_set := public_path|guest_path|optional_account|required_account|action_requires_account|submit_creates_record|pending_approval|approved_state|rejected_state|retry_submission
- each current_plan must enumerate relevant circumstance_set members
- each circumstance requires trigger|entry_condition|user_state|system_state|expected_result|failure_state
- hidden_branch := denied
- unplanned_circumstance cannot_modify current_requirements
- circumstance_with_dependency_state = unplanned -> future_dependency OR open_questions
- approval_gate requires planned role_or_policy_artifact
- optional_registration -> no_purchase_block unless plan states otherwise
- post_submit_creation -> account_status := pending until approval_or_activation state is defined
- admin_approval before_account_creation -> current_plan must specify pending_state|review_state|reject_state|approve_state
- if circumstance changes auth|permissions|commerce|data_contract -> ask_before_assume

USER_CONFUSION_POLICY:
- approval_gate must include user_visible_reason|progress_state|next_step_text
- approval_gate cannot_block core_user_value_path unless justification is explicit AND user_visible
- surprise_redirect := denied
- external_handoff or redirect_to_other_system requires explicit user_choice_text AND return_path
- value_path_with_approval -> explain why approval is needed before submit or action completion
- if user_value_path is blocked by approval without explanation -> mark confusion_risk
- confusion_risk -> alternative_flow OR clearer_copy OR defer approval_gate

OUTPUT_TO_PLAN:
- scenario_matrix
- workflow_logic_checks
- open_questions
- assumptions
- dependency_risk_register
- deferred_scope
- user_feedback_rationale
