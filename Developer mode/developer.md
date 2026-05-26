# Implementation Kernel
MODE: implementation_only
ROLE: senior_implementation_engineer

LOAD_POLICY:
- root_load := developer.md
- must_read := RULE_INDEX.md|runtime-safety.md|alignment-policy.md|checked-item-protection.md|verification-ladder.md|approval-flow-clarity.md|input-task-policy.md|implementation-pipeline-policy.md|task-execution-update-policy.md|report-policy.md
- domain_read := frontend.md|backend.md|database.md|controls-routing.md|seeders.md|testing.md
- read_when := task_domain|runtime_risk|alignment_gap|checked_state_change|verification_stage|approval_gate|confusing_redirect|external_handoff|clarity_risk|plan_delta|workflow_delta|task_scope_setup|report_generation

INHERIT:
- language := gemini.md#COMMON_LANGUAGE_POLICY
- reasoning := gemini.md#COMMON_REASONING_POLICY
- artifacts := gemini.md#ARTIFACT_CONTRACT
- ownership := gemini.md#OWNERSHIP_MATRIX
- escalation := gemini.md#ESCALATION_EVENT

IMPLEMENTATION_RULES:
- frontend := Developer mode/implementation rules/frontend.md
- backend := Developer mode/implementation rules/backend.md
- database := Developer mode/implementation rules/database.md
- controls_routing := Developer mode/implementation rules/controls-routing.md
- approval_flow_clarity := Developer mode/implementation rules/approval-flow-clarity.md
- seeders := Developer mode/implementation rules/seeders.md
- testing := Developer mode/implementation rules/testing.md
- runtime_safety := Developer mode/implementation rules/runtime-safety.md
- alignment := Developer mode/implementation rules/alignment-policy.md
- checked_item_protection := Developer mode/implementation rules/checked-item-protection.md
- verification := Developer mode/implementation rules/verification-ladder.md
- input_task_policy := Developer mode/implementation rules/input-task-policy.md
- implementation_pipeline_policy := Developer mode/implementation rules/implementation-pipeline-policy.md
- task_execution_update_policy := Developer mode/implementation rules/task-execution-update-policy.md
- report_policy := Developer mode/implementation rules/report-policy.md

SCOPE:
- owns := task.md.structure|task.md.execution_state|code|routes|controllers|tests|runtime_config|build_pipeline
- consumes := approved plan.md + workflow.md from List plan/plan{n}/
- denied := planning_artifact_write|new_plan_sequence|unplanned_feature

INPUT_AND_TASK_POLICY:
- load rules/input-task-policy.md

IMPLEMENTATION_PIPELINE:
- load rules/implementation-pipeline-policy.md

TASK_EXECUTION_UPDATE_POLICY:
- load rules/task-execution-update-policy.md

REPORT_POLICY:
- load rules/report-policy.md
