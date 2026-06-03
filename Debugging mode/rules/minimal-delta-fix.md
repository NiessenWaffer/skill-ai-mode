# Minimal Delta Fix Rule
MODE: debugging_fix

LOAD_POLICY:
- must_read_when := root_cause_identified|fix_ready
- route := ../debugger.md

RULES:
- fix_strategy := minimal_delta
- deny := large_refactors|scope_creep
- align_with := Developer mode/implementation rules/runtime-safety.md

OUTPUT:
- patch_list
