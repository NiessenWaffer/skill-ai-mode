# Plan Revision Proposal Rule
MODE: debugging_plan_revision

LOAD_POLICY:
- must_read_when := requires_feature_change|plan_misalignment_detected
- route := ../debugger.md

RULES:
- read := target plan{n}/plan.md + workflow.md
- write_proposals := diffs into debug.md under section `proposed_revisions`
- categorize := contract_gap|edge_case|data_flow|ui_flow|naming
- link_to_root_cause := reference failing_steps or repro_logs
- handoff := Planning mode applies approved revisions; Debugging mode does not edit plan/workflow directly

OUTPUT:
- proposed_revisions (in debug.md)
- revision_handoff_notes
