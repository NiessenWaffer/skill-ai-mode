# Section Action Data State Contract
MODE: planning_contract_validation

LOAD_POLICY:
- must_read_when := page_design|section_actions|data_contract|state_contract|missing_interactivity
- route := Planning mode/Planning.md

TARGET:
- inherit := Planning mode/Planning.md#LANGUAGE_POLICY
PURPOSE:
- section_completeness
- workflow_precision
- ui_contract_soundness
RULES:
- every_section requires content_contract + action_contract + data_contract + state_contract
- every_feature requires user_goal + trigger + expected_result + failure_state + required_feedback
- repeated_entity requires entity_action_map per card|row|list_item
- header/global actions require reachable section_action OR route_destination
- actionless_interactive_element := denied
- read_only_section requires explicit read_only_reason
- button_or_icon requires target_action + handler_or_route + feedback_state
- image_slot requires frontend_layout_spec + backend_or_seed_image_value_source
- action_contract_missing -> not_ready_for_workflow
OUTPUT_TO_PLAN:
- page_screen_contracts
- section_action_contracts
- design_content_strategy
- visual_asset_strategy
- workflow_logic_checks
