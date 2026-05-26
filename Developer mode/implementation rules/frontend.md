# Frontend Implementation Rule
MODE: frontend_implementation

TRIGGER:
- task touches UI|component|page|layout|interaction|asset|client_state

FRONTEND_FIRST_POLICY:
- first_implementation_surface := true
- build UI/layout/controls before backend/database implementation
- use mock_or_contract_data until backend data exists
- frontend decides image presentation := slot|aspect_ratio|object_fit|fallback_state|alt_text

PREFLIGHT:
- inspect := app_entrypoint|router_config|existing_components|design_tokens|assets|api_clients|state_store|forms
- reuse_existing_pattern := true
- duplicate_component := denied unless abstraction_needed

ACTION_UI_CONTRACT:
- every interactive_control requires action_contract
- controls := button|icon_button|link|dropdown|menu|tabs|modal|form|checkbox|toggle|slider|card_action|row_action|dots_menu
- action_control requires label_or_aria_label + handler + loading_state + success_feedback + failure_state
- decorative_icon requires non_interactive_marker
- actionless_card|actionless_icon|dead_button := denied
- global_indicator_control requires reachable source_action when same flow in scope

VISUAL_STATE_CONTRACT:
- states := default|hover|focus|active|disabled|loading|empty|error|success
- hover_visual_without_behavior := allowed only for non_interactive decorative surface
- interactive_hover requires clickable_or_focusable target
- keyboard_accessible := required for interactive controls

ASSET_CONTRACT:
- frontend owns image layout/presentation, not sample URL sourcing
- planned_image_required -> src_nonempty + alt_text + stable_dimensions + fallback_state
- backend_or_seeders supply sample image_url values for data entities
- blank_placeholder|empty_image_slot := denied

FUNCTIONAL_DONE:
- UI_action -> state_change OR route/request -> visible_result
- screenshot_or_manual_check required when UI exists
- frontend_only_visual_done.as_checked := denied unless task is explicitly visual_only


