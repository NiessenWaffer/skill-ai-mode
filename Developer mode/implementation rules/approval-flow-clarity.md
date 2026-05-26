# Approval Flow Clarity Rule
MODE: implementation_approval_flow_clarity

LOAD_POLICY:
- must_read_when := approval_gate|confusing_redirect|external_handoff|clarity_risk|core_user_value_path
- route := ../developer.md

TARGET:
- inherit := ../../gemini.md#COMMON_REASONING_POLICY
PURPOSE:
- prevent_hidden_approval_blockers
- preserve_user_value_path
RULES:
- approval_gate requires user_visible_reason|progress_state|next_step_text
- approval_gate cannot_block core_user_value_path unless justification is explicit AND user_visible
- external_handoff or redirect_to_other_system requires explicit user_choice_text AND return_path
- if approval_flow blocks the primary action path without explanation -> mark clarity_risk
- clarity_risk -> alternative_flow OR clearer_copy OR route_to Planning mode revision
OUTPUT:
- risk_notes
- implementation_notes
