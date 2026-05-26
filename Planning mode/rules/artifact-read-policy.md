# Artifact Read Policy
MODE: planning_artifact_read_policy

LOAD_POLICY:
- must_read_when := new_plan|revision|integration_context|artifact_graph|handoff|related_plan_overlap|backend_extension_needed|merge_candidate
- route := Planning mode/Planning.md

TARGET:
- inherit := Planning mode/Planning.md#LANGUAGE_POLICY
PURPOSE:
- artifact_graph_loading
- read_scope_control
RULES:
- sequence_allocation := inherit gemini.md#ARTIFACT_CONTRACT.sequence_id|sequence_gap
- artifact_unit := inherit gemini.md#ARTIFACT_CONTRACT.artifact_unit
- index_row := sequence_id|artifact_name|artifact_scope|folder|plan_file|workflow_file|task_file|status|depends_on|connected_to
- integration_context := related_plan_ids|shared_entities|shared_roles|shared_navigation|dependencies|handoff_points|separate_project_reason
- connected_artifacts := connected_to|connected_files|connection_scope|connection_reason|read_required_for_revision|read_required_for_implementation
- connection_scope := direct_dependency|shared_entity|shared_role|shared_navigation|same_user_journey|data_contract|permission_boundary|visual_consistency
- bidirectional_connection -> update both plan.md files + index.connected_to
- plan2_plus requires integration_context OR separate_project_reason
- new_plan -> read List plan/index.md + existing List plan/plan*/plan.md for integration_context only
- new_plan related_plan_scan := compare current proposal against prior plan scopes|goals|entities|roles|navigation|dependency_contracts|permission_boundaries|same_user_journey
- related_plan_overlap -> prefer revise_existing_plan OR extend_predecessor_plan OR connect_plans
- related_plan_overlap with backend_support_needed -> mark merge_candidate and connect_to_origin_plan rather than isolate
- merge_candidate requires explicit revision_target OR connected_to plan_id
- revision_target != new isolated sequence unless separate_project_reason is explicit
- new_plan.previous_sections_copy := denied
- new_plan.reuse := shared_entities|shared_roles|shared_navigation|canonical_terms
- revision -> read current plan.md + workflow.md + connected_artifacts where read_required_for_revision = true
- revision with related_plan_overlap -> inspect predecessor plans before patching same plan{n}
- unrelated_same_system -> canonical_terms_only; skip_full_read
OUTPUT:
- artifact_graph_state
- integration_context
- connected_artifacts
- merge_candidate
- revision_target
