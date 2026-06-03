# Root Cause Hypothesis Rule
MODE: debugging_hypothesis

LOAD_POLICY:
- must_read_when := repro_observed|symptom_pattern|component_suspected
- route := ../debugger.md

RULES:
- generate_prioritized_hypotheses := 3..7 items
- experiment_design := minimize_cost_maximize_signal
- choose_next := highest_signal_low_cost

OUTPUT:
- hypothesis_list
- experiment_plan
