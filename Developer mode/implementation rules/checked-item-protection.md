# Checked Item Protection Rule
MODE: implementation_check_state

LOAD_POLICY:
- must_read_when := checked_state_change|rework_risk|upstream_delta|bug_evidence
- route := Developer mode/developer.md

TARGET:
- inherit := gemini.md#COMMON_REASONING_POLICY
PURPOSE:
- preserve_checked_work
RULES:
- checked_item := implemented_contract
- checked_item_change requires upstream_delta OR bug_evidence
- accidental_rework := denied
- affected_checked_item -> mark review_required
- preserve_working_behavior := true
OUTPUT:
- check_state
- verification_notes
