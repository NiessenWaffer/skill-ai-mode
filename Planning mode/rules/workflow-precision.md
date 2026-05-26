# Workflow Precision Rule
MODE: planning_workflow_precision

LOAD_POLICY:
- must_read_when := workflow_create|workflow_update|user_flow_precision|implementation_order
- route := ../Planning.md

TARGET:
- inherit := ../Planning.md#LANGUAGE_POLICY
PURPOSE:
- workflow_sequence_clarity
- implementation_transferability
RULES:
- workflow must describe what_user_does step_by_step
- workflow_step_schema := actor|trigger|screen_or_entrypoint|action|system_response|state_change|success_state|failure_state
- frontend_first_sequence := required for implementation_order
- frontend_step := layout|image_slots|controls|states|mock_or_contract_data
- backend_step := routes|controllers|services|validation|response_shape
- database_step := schema|relationships|queries|persistence_rules
- seeder_step := sample_records|image_url_sources|state_variants
- testing_step := functional_user_flow_verification
- untraced_workflow_item -> reject OR move_to open_questions
- workflow_delta -> developer_task_regeneration_required
OUTPUT_TO_PLAN:
- workflow.md
- primary_user_workflows
- workflow_logic_checks
- section_action_contracts
- verification_flow
