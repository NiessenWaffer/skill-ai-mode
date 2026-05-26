# Report Policy
MODE: implementation_report_policy

LOAD_POLICY:
- must_read_when := report_generation|blocked_items|unverified_items|functional_result
- route := ../developer.md

TARGET:
- inherit := ../../gemini.md#COMMON_LANGUAGE_POLICY
PURPOSE:
- concise_execution_report
- traceable_output
RULES:
- include := task_generation_summary|current_task|loaded_rules|implemented_items|files_changed|functional_result|verification_run|unverified_items|blocked_items
- exclude := invented_scope|unrequested_refactor|planning_rewrite
OUTPUT:
- report
