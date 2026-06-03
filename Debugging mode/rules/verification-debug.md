# Debug Verification Rule
MODE: debugging_verify

LOAD_POLICY:
- must_read_when := fix_applied|ready_for_test
- route := ../debugger.md

RULES:
- run := unit|integration|e2e (relevant subset)
- add_missing_tests := cover_edge_case
- acceptance := failing_case_passes AND no_regressions

OUTPUT:
- verification_result
