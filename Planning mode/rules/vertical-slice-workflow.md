# Workflow Contract Rule
MODE: vertical_slice_workflow
TARGET:
- file := List plan/plan{n}/workflow.md
- inherit := ../Planning.md#LANGUAGE_POLICY
- derivation := ../Planning.md#DERIVATION_CHAIN

TRIGGER:
- plan{n}/plan.md exists
- plan.status = ready_for_workflow

SOURCE_PLAN_POLICY:
- source_plan := List plan/plan{n}/plan.md
- trace_required := primary_user_workflows|page_screen_contracts|section_action_contracts|success_criteria
- source_plan.missing|draft -> stop
- untraced_requirement -> add_to_plan OR open_question

ANTI_PATTERNS:
- database_first_sequence
- schema_complete_before_frontend_contract
- phase_list_without_user_workflow_anchor
- vague_step_like_build_backend|make_frontend|setup_database

CORE_SEQUENCE:
- frontend_first_contract -> controls_routing -> backend_support -> database_persistence -> seed_data -> functional_testing

USER_FLOW_CONTRACT:
- step := actor|trigger|screen_or_entrypoint|action|system_response|state_change|success_state|failure_state
- each action_contract maps_to at least one workflow_step
- each workflow_step maps_to visible_result OR observable_result
- missing_failure_state := not_ready_for_developer_tasking

SLICE_CONTRACT:
- minimal_foundation := framework_env_dependencies|project_structure|frontend_entry|routing_entry
- slice_keys := user_workflow|frontend_layout_controls|image_slots|sample_data_contract|route_controller_contract|api_or_view_connection|permissions_error_states|planned_verification|data_schema_refinements

DATA_POLICY:
- schema.discovery := after frontend_contract and user_flow are clear
- schema.fields := current_slice_required only
- schema.refine_if missing_data_exposed
- sample_data_contract := entity|minimum_records|required_variants|relationships|image_fields|UI_states_supported|image_url_source
- minimum_records.default := 5..12 unless singleton_entity

OUTPUT_SCHEMA:
- title := # Project Workflow Contract
- identity := sequence_id|artifact_folder|source_plan|status
- status := ready_for_developer_tasking
- sections := precise_user_flow|frontend_first_sequence|controls_routing|backend_contract|database_contract|sample_data_contract|verification_flow|risks_unknowns|not_yet_implementing
- dependency_order := frontend_first_sequence + vertical_slices ordered_by user_flow_dependency

OUTPUT_RULES:
- include sequence_rationale per slice
- artifact_type := planning_only
- workflow_scope = source_plan.artifact_scope
- unrelated_plan_slices := denied
