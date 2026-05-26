# Alignment Policy
MODE: implementation_alignment

LOAD_POLICY:
- must_read_when := alignment_gap|route_change|payload_change|image_alignment|contract_change
- route := ../developer.md

TARGET:
- inherit := ../../gemini.md#COMMON_REASONING_POLICY
PURPOSE:
- keep_code_aligned_with_plan
RULES:
- planned_action_contract required for interactive UI controls
- route_alignment := UI_controls + routes + handlers + state_changes
- data_alignment := migration + model + validation + API + frontend_payload + UI_state + seed_data
- image_alignment := frontend_image_layout + backend_or_seed_image_url_value
- naming_mismatch -> add_adapter_mapping OR request Planning mode revision when contract_change_needed
- missing_in_scope_route_or_handler -> implement wiring
- missing_out_of_scope_contract -> request Planning mode revision
OUTPUT:
- files_changed
- functional_result
