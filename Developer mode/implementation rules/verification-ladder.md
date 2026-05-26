# Verification Ladder Rule
MODE: implementation_verification

LOAD_POLICY:
- must_read_when := verification_stage|checked_state_change|flow_validation|task_done_review
- route := Developer mode/developer.md

TARGET:
- inherit := gemini.md#COMMON_REASONING_POLICY
PURPOSE:
- evidence_based_completion
RULES:
- task_done := functional_user_flow_passed AND verification_passed
- layer_only_completion := migration_only|model_only|controller_only|route_only|frontend_only|seed_only
- layer_only_completion.as_checked := denied
- required_flow_path := entrypoint -> route_or_handler -> validation -> domain_logic -> persistence_or_side_effect -> response -> UI_or_caller_state
- user_facing_task requires UI_action -> request_or_navigation -> backend_or_state_update -> visible_result
- non_UI_task requires callable_entrypoint -> handler -> expected_result -> observable_verification
- every_small_detail_created must be functional before next task
- small_detail := icon_button|dropdown|hover_state|menu|dots_menu|link|form_field|empty_state|loading_state|error_state
- partial_layer_done -> keep unchecked + record implementation_notes
- failing_flow -> fix_same_task_before_next_task
- scope_gap_detected -> request Planning mode revision; do_not_mark_checked
- check_state.checked requires TASK_FUNCTIONALITY_GATE.pass
- advance_to_next_task requires current_task.functional_pass = true OR blocked_state.recorded
- verification_evidence required before check_state = checked
OUTPUT:
- verification_run
- unverified_items
