# Repro Harness Rule
MODE: debugging_repro

LOAD_POLICY:
- must_read_when := repro_needed|cannot_reproduce|unit_available|integration_available
- route := ../debugger.md

RULES:
- prefer_unit_or_small_integration := true
- record_steps := exact_inputs + observed_outputs
- inline_fixture := allowed (temporary)
- persistent_fixture := denied unless necessary

OUTPUT:
- repro_steps
- harness_snippets
