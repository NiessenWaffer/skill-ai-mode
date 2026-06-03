# Instrumentation & Logging Rule
MODE: debugging_instrumentation

LOAD_POLICY:
- must_read_when := low_signal|cannot_reproduce|need_state_visibility
- route := ../debugger.md

RULES:
- add_temp_logging|assertions|traces := minimal
- avoid := secrets|pii|performance_regressions
- cleanup := remove_temp_after_fix

OUTPUT:
- instrumentation_plan
