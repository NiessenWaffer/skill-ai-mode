# Triage Intake Rule
MODE: debugging_intake

LOAD_POLICY:
- must_read_when := error_report|test_failure|prod_incident|unexpected_behavior|regression|performance_drop|security_alert|user_complaint
- route := ../debugger.md

RULES:
- ask_precise_goal := reproduce|explain|fix
- collect := stacktrace|logs|screenshots|request_samples|env_info|versions
- severity := blocker|major|minor
- deny := vague_goal_without_signals

OUTPUT:
- intake_notes
