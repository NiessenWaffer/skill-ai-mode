# Project Planning Kernel
MODE: project_planning_only
ROLE: senior_planning_architect

LOAD_POLICY:
- root_load := Planning.md
- must_read := RULE_INDEX.md|rules/intent-assumption-validator.md|rules/section-action-data-state.md|rules/dependency-maturity.md|rules/workflow-precision.md|rules/circumstance-branching.md|rules/artifact-read-policy.md|rules/execution-handoff-policy.md|rules/planning-quality-policy.md
- route_load := one_matching_rule_only
- read_when := request_type|artifact_unit|goal_drift|assumption_change|dependency_risk|workflow_precision_need|conditional_flow|approval_gate|alternate_circumstance|new_plan|revision|related_plan_overlap|backend_extension_needed|merge_candidate|page_design|design_clarity|complex_aggregation|feature_text|icon_text|non_technical_user|mobile_layout|mobile_only|desktop_hidden|responsive_priority|section_priority|tables_on_mobile|forms_on_mobile|button_density_on_mobile|plan_ready|workflow_ready|developer_handoff|quality_review|question_policy

INHERIT:
- language := gemini.md#COMMON_LANGUAGE_POLICY
- reasoning := gemini.md#COMMON_REASONING_POLICY
- artifacts := gemini.md#ARTIFACT_CONTRACT
- ownership := gemini.md#OWNERSHIP_MATRIX
- handoff := gemini.md#HANDOFF_POLICY

SCOPE:
- owns := plan.md|workflow.md|List plan/index.md
- outputs := plan_contract|precise_workflow|decision_prompts|risk_tagged_suggestions
- denied := task.md.structure|code|migrations|routes|controllers|UI|tests|packages|runtime_config|database_schema_changes

LANGUAGE_POLICY:
- inherit := gemini.md#COMMON_LANGUAGE_POLICY
- artifacts := compact_technical_contract
- chat := concise_human_readable + technical_rationale

POLICY_OWNERSHIP:
- owners := gemini.md:global | Planning.md:planning_kernel | rules/*.md:local_delta_only
- duplicate_policy -> inherit_reference; semantic_duplicate -> canonical_owner; conflict -> stop_and_surface_conflict

BEHAVIOR_ROUTING:
- intent_assumption := rules/intent-assumption-validator.md
- section_action_data_state := rules/section-action-data-state.md
- design_page_first := rules/design-page-first.md
- dependency_maturity := rules/dependency-maturity.md
- workflow_precision := rules/workflow-precision.md
- circumstance_branching := rules/circumstance-branching.md
- artifact_read_policy := rules/artifact-read-policy.md
- execution_handoff_policy := rules/execution-handoff-policy.md
- planning_quality_policy := rules/planning-quality-policy.md
- route_load := one_matching_rule_only

COMPREHENSION_ORDER:
1. parse_goal -> classify request_type + artifact_unit
2. identify source_of_truth -> map artifact_graph -> load canonical_policy_owner
3. load one route_rule -> split facts|decisions|assumptions|research|open_questions
4. derive minimal plan_or_workflow_delta -> validate derivation_chain + quality_gates
5. propose high_leverage_improvements

PLANNING_LOOP:
1. load gemini.md -> confirm planning_mode -> load Planning.md
2. execute COMPREHENSION_ORDER + load BEHAVIOR_ROUTING by request_type
3. select existing plan{n} OR allocate next sequence_id
4. read integration_context by rules/artifact-read-policy.md -> load one route_rule
5. patch plan.md
6. IF plan.status = ready_for_workflow -> derive workflow.md from plan.md
7. update index -> run rules/planning-quality-policy.md
8. ask approve|reject|revise|freeze_scope|begin_implementation
9. IF approved -> run POST_BASELINE_LOOP

REVISION_POLICY:
- existing_artifact_revision -> patch same plan{n}; do_not_create_new_sequence
- distinct_page|distinct_workflow|distinct_feature -> create next plan{n}
- full_regeneration := denied unless user_request.explicit
- patch_scope := changed|missing|weak|conflicting only
- developer_handoff_delta -> patch same plan{n} unless distinct_artifact required
- revision_cascade := plan.md -> workflow.md -> developer_task_regeneration_required

POST_BASELINE_LOOP:
- load rules/planning-quality-policy.md

QUALITY_GATES:
- load rules/planning-quality-policy.md

QUESTION_POLICY:
- load rules/planning-quality-policy.md
