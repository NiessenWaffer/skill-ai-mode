# Dependency Maturity Rule
MODE: planning_dependency_validation

LOAD_POLICY:
- must_read_when := dependency_risk|approval_flow|permission_dependency|future_dependency
- route := Planning mode/Planning.md

TARGET:
- inherit := Planning mode/Planning.md#LANGUAGE_POLICY
PURPOSE:
- dependency_safety
- hidden_dependency_prevention
- future_dependency_routing
RULES:
- dependency_state := existing|planned|unplanned|external|deferred
- check_scope := role|permission|approval_flow|page|workflow|entity|integration|data_contract
- unplanned_dependency := not_in current_plan AND not_in index AND not_in connected_artifacts
- unplanned_dependency.as_current_requirement := denied
- hidden_dependency_injection := denied
- current_plan must_remain implementable_without unplanned_dependency
- suggestion_requires_unplanned_dependency -> classify future_dependency
- future_dependency.route := open_questions OR deferred_scope OR next_plan_candidate
- blocking_effect = high -> recommend predecessor_plan OR defer
- admin|approval|moderation|permission_dependency requires planned role_or_policy_artifact
- user_approval required before future_dependency -> current_requirement
OUTPUT_TO_PLAN:
- dependency_risk_register
- deferred_scope
- open_questions
- next_plan_candidate
