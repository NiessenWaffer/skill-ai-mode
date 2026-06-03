# Testing Implementation Rule
MODE: testing_implementation

TRIGGER:
- always_load before marking task checked

TASK_FUNCTIONALITY_GATE:
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

VERIFICATION_LADDER:
1. static_read
2. typecheck_or_lint_if_available
3. unit_test_if_exists
4. integration_path_check
5. manual_browser_check_if_UI
6. screenshot_check_if_visual_UI
7. report_unverified_paths

CHECK_STATE_RULE:
- check_state.checked requires TASK_FUNCTIONALITY_GATE.pass
- advance_to_next_task requires current_task.functional_pass = true OR blocked_state.recorded
- verification_evidence required before check_state = checked

TEST_DATABASE_SAFETY:
- test_database_refresh|test_truncate_tables|test_RefreshDatabase := denied unless isolated_test_database
- IF shared_database_detected AND test_destructive_trait_detected -> stop_and_request_user_approval
- test_run_against_production_database := denied
- test_seed_after_truncate -> verify_backup_or_explicit_user_approval
