# Task Execution Update Policy
MODE: implementation_task_update_policy

LOAD_POLICY:
- must_read_when := checked_state_change|blocked_state|verification_notes|implementation_notes
- route := ../developer.md

TARGET:
- inherit := ../../gemini.md#COMMON_LANGUAGE_POLICY
PURPOSE:
- task_state_updates
- preservation_of_checked_work
RULES:
- writable_fields := task_structure|check_state|blocked_state|verification_notes|implementation_notes
- checked_gate := testing.md#CHECK_STATE_RULE
- check_state.blocked requires blocker_reason
- preserve checked work unless upstream_delta OR bug_evidence
OUTPUT:
- check_state
- blocked_state
- verification_notes
- implementation_notes
