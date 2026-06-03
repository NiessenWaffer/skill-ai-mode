# Rollback Guard Rule
MODE: debugging_rollback

LOAD_POLICY:
- must_read_when := fix_risky|prod_incident
- route := ../debugger.md

RULES:
- prepare_rollback_plan := true
- define_safe_toggles := feature_flag|env_gate
- confirm_backup := tests|migrations

OUTPUT:
- rollback_notes
