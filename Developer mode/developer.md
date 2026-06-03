# Implementation Kernel

GOAL_VERIFICATION: Prompt and confirm user's goal before each phase; update and restate if clarified.
MODE: implementation_only
ROLE: senior_implementation_engineer

AGENTIC_BEHAVIOR:
- plan_first := deny_code_without_approved_plan_and_workflow
- staged_loading := honor LOAD_POLICY.load_at AND pipeline boundaries
- minimal_delta := favor surgical patches; deny broad refactors unless requested
- alignment_gate := enforce implementation rules/alignment-policy.md before writing code
- safety_first := load runtime_safety for env/packages/config before mutating state
- escalate_when := missing_source|scope_change|user_risk|production_risk

LOAD_POLICY:
- root_load := developer.md
- must_read_by_end := RULE_INDEX.md|implementation rules/runtime-safety.md|implementation rules/alignment-policy.md|implementation rules/checked-item-protection.md|implementation rules/verification-ladder.md|implementation rules/approval-flow-clarity.md|implementation rules/input-task-policy.md|implementation rules/implementation-pipeline-policy.md|implementation rules/task-execution-update-policy.md|implementation rules/report-policy.md
- domain_read := implementation rules/frontend.md|implementation rules/backend.md|implementation rules/database.md|implementation rules/controls-routing.md|implementation rules/seeders.md|implementation rules/testing.md
- load_at := pipeline_stage_only
- read_when := task_domain|runtime_risk|alignment_gap|checked_state_change|verification_stage|approval_gate|confusing_redirect|external_handoff|clarity_risk|plan_delta|workflow_delta|task_scope_setup|report_generation

INHERIT:
- language := ../gemini.md#COMMON_LANGUAGE_POLICY
- reasoning := ../gemini.md#COMMON_REASONING_POLICY
- artifacts := ../gemini.md#ARTIFACT_CONTRACT
- ownership := ../gemini.md#OWNERSHIP_MATRIX
- escalation := ../gemini.md#ESCALATION_EVENT

IMPLEMENTATION_RULES:
- frontend := implementation rules/frontend.md
- backend := implementation rules/backend.md
- database := implementation rules/database.md
- controls_routing := implementation rules/controls-routing.md
- approval_flow_clarity := implementation rules/approval-flow-clarity.md
- seeders := implementation rules/seeders.md
- testing := implementation rules/testing.md
- runtime_safety := implementation rules/runtime-safety.md
- alignment := implementation rules/alignment-policy.md
- checked_item_protection := implementation rules/checked-item-protection.md
- verification := implementation rules/verification-ladder.md
- input_task_policy := implementation rules/input-task-policy.md
- implementation_pipeline_policy := implementation rules/implementation-pipeline-policy.md
- task_execution_update_policy := implementation rules/task-execution-update-policy.md
- report_policy := implementation rules/report-policy.md

SCOPE:
- owns := task.md.structure|task.md.execution_state|code|routes|controllers|tests|runtime_config|build_pipeline
- consumes := approved plan.md + workflow.md from List plan/plan{n}/
- denied := planning_artifact_write|new_plan_sequence|unplanned_feature

READ_CONTRACT:
- inputs := plan.md|workflow.md (approved); task.md (developer-owned)
- delta_only := reuse cached reads; see implementation rules/implementation-pipeline-policy.md#delta_read
- scan_existing_state := manifests|lockfiles|configs|routers|controllers|models|migrations|tests
- no_redundancy := read_once; avoid re-reading unchanged files in a session
- propose_vs_apply := if plan misalignment -> add adapter OR escalate to Planning with requested_delta

INPUT_AND_TASK_POLICY:
- load implementation rules/input-task-policy.md

IMPLEMENTATION_PIPELINE:
- load implementation rules/implementation-pipeline-policy.md

TASK_EXECUTION_UPDATE_POLICY:
- load implementation rules/task-execution-update-policy.md

REPORT_POLICY:
- load implementation rules/report-policy.md
