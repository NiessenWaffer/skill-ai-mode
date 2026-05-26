# Plan Contract Rule
MODE: plan_artifact_update
TARGET:
- file := List plan/plan{n}/plan.md
- inherit := Planning mode/Planning.md#LANGUAGE_POLICY
- graph := Planning mode/Planning.md#ARTIFACT_GRAPH
SCHEMA_GROUPS:
- identity := sequence_id|artifact_name|artifact_folder|artifact_scope|depends_on|status|mode
- goal := project_goal|target_users|success_criteria
- page_design := page_screen_contracts|section_action_contracts|design_content_strategy|visual_asset_strategy
- integration := integration_context|connected_artifacts|dependency_risk_register|related_plan_resolution|merge_candidate|revision_target
- workflow := primary_user_workflows|workflow_logic_checks
- system_contract := roles_permissions|core_entities_data|pages_screens_api_surfaces|business_rules
- external_contract := integrations|notifications_reports
- scope := MVP_scope|deferred_scope
- evidence := research_notes|assumptions|open_questions
RENDER_CONTRACT:
- title := # Project Plan Contract
- required_keys := identity + goal + page_design + integration + workflow + system_contract + external_contract + scope + evidence
- key_order := identity -> goal -> page_design -> integration -> workflow -> system_contract -> external_contract -> scope -> evidence
- status_values := draft|ready_for_workflow
- mode_values := user_filled|interactive_discovery
STATE:
- draft -> blocker_info.missing
- ready_for_workflow -> blocker_questions.count = 0 AND integration_context.valid
CONTEXT_RULES:
- plan2_plus := Planning mode/Planning.md#ARTIFACT_GRAPH.plan2_plus
- integration_context.one_of := related_plan_ids|shared_entities|shared_roles|shared_navigation|dependencies|handoff_points|separate_project_reason
- connected_artifacts.required_if := direct_dependency|shared_user_journey|shared_data_contract|shared_permission_rule|shared_navigation_transition
- connected_artifacts.schema := connected_to|connected_files|connection_scope|connection_reason|read_required_for_revision|read_required_for_implementation
- related_plan_resolution.one_of := revise_existing_plan|extend_predecessor_plan|connect_plans|create_distinct_new_plan
- previous_plan_text.duplicate := denied
WRITE_MAP:
- user_answer.meaningful -> matching_section
- research_finding -> research_notes
- claim.uncertain -> assumptions|open_questions
- scope.rejected|deferred -> deferred_scope
- page_visual_placeholder -> visual_asset_strategy
- section_action_contract -> section_action_contracts|primary_user_workflows|workflow_logic_checks
- related_plan_context -> integration_context|connected_artifacts|depends_on|related_plan_resolution|merge_candidate|revision_target
- future_dependency|unplanned_dependency -> dependency_risk_register|deferred_scope|open_questions|related_plan_resolution
REVISION:
- same_artifact -> patch same plan{n}
- related_artifact_overlap -> revise_same_plan OR connect_predecessor_plan + new_supported_plan
- distinct_artifact -> create next plan{n}
- preserve := sequence_id|artifact_name|artifact_folder unless rename_explicit
INVARIANTS:
- quality_gates := Planning mode/Planning.md#QUALITY_GATES
- artifact_unit := Planning mode/Planning.md#ARTIFACT_GRAPH.artifact_unit
- dependency_policy := Planning mode/Planning.md#DEPENDENCY_POLICY



