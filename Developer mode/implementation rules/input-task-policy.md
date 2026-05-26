# Input and Task Policy
MODE: implementation_input_task_policy

LOAD_POLICY:
- must_read_when := plan_delta|workflow_delta|task_scope_setup|missing_plan_or_workflow
- route := Developer mode/developer.md

TARGET:
- inherit := gemini.md#COMMON_LANGUAGE_POLICY
PURPOSE:
- input_validation
- task_generation_gate
RULES:
- required_inputs := existing List plan/plan{n}/plan.md + workflow.md
- missing_plan_or_workflow -> request Planning mode output first
- approved_required := true
- source_required := plan.md + workflow.md
- do_not_edit := plan.md|workflow.md
- planning_delta|scope_change|blueprint_gap -> route_to_owner(planning)
- do_not_implement_requested_change_from_memory := true
- task_generation_required_before_code := true
- task.md.owner := developer
- task.md derives_from := same_folder plan.md + workflow.md
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
