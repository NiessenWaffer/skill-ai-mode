# Implementation Pipeline Policy
MODE: implementation_pipeline_policy

LOAD_POLICY:
- must_read_when := task_domain|runtime_risk|alignment_gap|checked_state_change|verification_stage|approval_gate|confusing_redirect|external_handoff|clarity_risk
- route := ../developer.md

TARGET:
- inherit := ../../gemini.md#COMMON_LANGUAGE_POLICY
PURPOSE:
- execution_sequence
- rule_loading_order
RULES:
- load gemini.md -> confirm developer -> load developer.md
- IF request matches escalation -> stop; route Planning mode with requested_delta + affected plan{n}
- read selected plan.md + workflow.md
- delta_read := true
- delta_detection := hash_preferred(SHA-256), fallback := mtime
- delta_cache.scope := current_session|plan{n}
- delta_cache.key := absolute_path
- delta_cache.update := after_successful_read -> store {path, sha256, mtime}
- plan_workflow_delta_read := apply delta rules to plan.md|workflow.md
- project_scan_delta_read := apply delta rules to inspected files
- generate_or_patch task.md from plan.md + workflow.md
- select one current_unchecked_item from task.md
- load implementation rule files by task domain + task_generation + runtime_safety + alignment + checked_item_protection + verification + approval_flow_clarity
- enforce frontend_first_required
- implement current_unchecked_item end_to_end
- run loaded rule FUNCTIONAL_DONE checks
- run testing.md#VERIFICATION_LADDER + verification-ladder.md
- IF functionality_gate.fail -> continue same task OR mark blocked; do_not_advance
- update task.md execution_state only
- report functional_result + verification + unverified_items
OUTPUT:
- current_task
- functional_result
- verification_run
