# Task Generation Rule
MODE: task_generation_validation

LOAD_POLICY:
- must_read_when := task.md_generation|plan_delta|workflow_delta|task_scope_setup
- route := ../developer.md

TARGET:
- inherit := ../../gemini.md#COMMON_LANGUAGE_POLICY
PURPOSE:
- derive task.md from plan.md + workflow.md
RULES:
- task.md.owner := developer
- task.md derives_from := same_folder plan.md + workflow.md
- task_generation_required_before_code := true
- task_generation_input_scan := plan.sections|workflow.precise_user_flow|section_action_contracts|frontend_first_sequence|data_contracts|sample_data_contract|verification_flow
- task_item_schema := checkbox|task_id|source_plan_section|source_workflow_step|implementation_rule|implementation_scope|files_areas|functional_done_check|execution_state
- task_order := frontend_first -> controls_routing -> backend -> database -> seeders -> testing
- first_implementation_task := frontend_contract_or_UI_shell
- task_standalone_creation := denied
- plan_or_workflow_delta -> regenerate_or_patch task.md before implementation
- preserve execution_state when task_id still valid
- changed_checked_item -> mark review_required
OUTPUT:
- task.md
- task_generation_summary
