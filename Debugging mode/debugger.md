# Debugging Kernel

MODE: debugging_only
ROLE: senior_debug_engineer

LOAD_POLICY:
- root_load := debugger.md
- must_read_by_end := RULE_INDEX.md|rules/triage-intake.md|rules/repro-harness.md|rules/root-cause-hypothesis.md|rules/instrumentation-logging.md|rules/minimal-delta-fix.md|rules/verification-debug.md|rules/rollback-guard.md
- load_at := stage_only
- read_when := error_report|test_failure|prod_incident|unexpected_behavior|regression|performance_drop|security_alert|user_complaint

INHERIT:
- language := ../gemini.md#COMMON_LANGUAGE_POLICY
- reasoning := ../gemini.md#COMMON_REASONING_POLICY
- artifacts := ../gemini.md#ARTIFACT_CONTRACT
- ownership := ../gemini.md#OWNERSHIP_MATRIX
- escalation := ../gemini.md#ESCALATION_EVENT

DEBUG_ARTIFACT:
- file := List plan/plan{n}/debug.md
- semantics := debug_plan_only (not a product feature plan)
- allowed_links := plan.md|workflow.md (read + propose_revision; actual edits by Planning mode)

DELTA_STRATEGY:
- delta_read := true
- delta_detection := hash_preferred(SHA-256), fallback := mtime
- delta_cache.scope := current_session|plan{n}
- delta_cache.key := absolute_path
- delta_cache.update := after_successful_read -> store {path, sha256, mtime}

RELATED_ARTIFACTS_READ:
- read_existing_unit := List plan/plan{n}/plan.md + workflow.md
- read_related_units := scan List plan/index.md for overlapping flows
- selection := user_confirms_target_plan{n}

PHASES:

D1_INTAKE:
- clarify_user_goal := reproduce_or_explain_or_fix
- collect_signals := stacktrace|logs|screenshots|request_samples|env_info|versions
- severity := classify(blocker|major|minor)
- write_to debug.md := goal|context|signals|initial_notes

D2_REPRO:
- attempt_minimal_repro := true
- build_repro_harness := prefer_unit_or_small_integration
- record_steps := exact_inputs + observed_outputs
- IF cannot_reproduce -> instrument_more OR request_user_steps

D3_SCOPE_IMPACT:
- map_components := routes|handlers|services|schemas|migrations|ui_components
- scan_git := recent_diffs_related_to_area
- test_inventory := relevant_tests + coverage_gaps
- impact_surface := user_flows|data_entities|environments
- read_plan_artifacts := plan.md + workflow.md (target plan{n})

D4_HYPOTHESES:
- generate_prioritized_hypotheses := 3..7 items
- design_small_experiments := to_disprove_false
- choose_next_experiment := highest_signal_low_cost

D5_INSTRUMENT:
- add_temp_logging|assertions|traces := minimal_footprint
- guardrails := remove_after_fix|no_secrets|no_pii
- verify_signal_quality := logs_show_expected_state

D6_FIX:
- strategy := minimal_delta_fix_only
- avoid := scope_creep|refactors_unrelated
- follow := rules/minimal-delta-fix.md + runtime_safety

D7_VERIFY:
- run_tests := unit|integration|e2e (relevant subset first)
- add_missing_tests := prevent_regression
- acceptance := failing_case_now_passes AND no_existing_breakages

D8_POSTMORTEM:
- rc_summary := what_broke|why|how_detected
- prevention := tests|lint|alerts|process
- update debug.md := final_notes|fix_hash|verification
- IF requires_feature_change -> propose_revisions := plan.md|workflow.md (write diff/suggestions into debug.md) -> escalate_to Planning mode to apply

SAFETY:
- destructive_operations := denied
- production_data_writes := denied
- env_secret_print := denied
- follow runtime_safety := Developer mode/implementation rules/runtime-safety.md

OUTPUT:
- artifacts := debug.md (plan_only), patch_list, verification_result, root_cause_summary
