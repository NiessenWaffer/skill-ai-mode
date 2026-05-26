# Execution Handoff Policy
MODE: planning_execution_handoff

LOAD_POLICY:
- must_read_when := plan_ready|workflow_ready|developer_handoff|revision_cascade
- route := Planning mode/Planning.md

TARGET:
- inherit := Planning mode/Planning.md#LANGUAGE_POLICY
PURPOSE:
- developer_handoff
- execution_order_control
RULES:
- plan.md := root_source_of_truth
- workflow.md derives_from same_folder plan.md only
- task.md derives_by developer from plan.md + workflow.md
- workflow_standalone_creation := denied
- planning_task_generation := denied
- untraced_workflow_item -> reject OR move_to open_questions
- plan_delta -> workflow_delta_check required
- workflow_delta -> developer_task_regeneration_required
- handoff_input := plan.md + workflow.md
- task_generation_owner := developer
- handoff_requires := plan.status = ready_for_workflow AND workflow.status = ready_for_developer_tasking
- task.md may exist empty before developer_task_generation
- developer regenerates task.md when plan_or_workflow_delta exists
- existing_artifact_revision -> patch same plan{n}; do_not_create_new_sequence
- distinct_page|distinct_workflow|distinct_feature -> create next plan{n}
- full_regeneration := denied unless user_request.explicit
- patch_scope := changed|missing|weak|conflicting only
- developer_handoff_delta -> patch same plan{n} unless distinct_artifact required
- revision_cascade := plan.md -> workflow.md -> developer_task_regeneration_required
OUTPUT:
- handoff_input
- revision_cascade
- developer_task_regeneration_required
