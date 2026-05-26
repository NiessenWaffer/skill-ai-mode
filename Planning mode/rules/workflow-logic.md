# Workflow Logic Contract
MODE: workflow_logic_validator
INHERIT:
- language_policy := Planning mode/Planning.md#LANGUAGE_POLICY
TRIGGER:
- candidate := field|page|role|feature|workflow
- validate plan.scope
- detect assumption.random|scope_creep
CORE_CHECK:
- candidate.belongs_to(current_workflow, target_user, workflow_moment)?
WORKFLOW_CONTRACT:
- user_intent|trigger_entry|preconditions|expected_inputs|expected_output|owner_workflow|excluded_scope
DECISION_RULES:
- IF user.role AND user.goal -> item.supports(user.goal) required
- IF item.precondition_missing -> defer until precondition.exists
- IF item.owner_workflow != current_workflow -> move item to owner_workflow OR excluded_scope
- IF item.common_in_domain AND item.required_now = false -> exclude
- IF decision.impacts auth|permissions|billing|privacy|deletion|core_rules -> ask_before_assume
INVARIANTS:
- reject domain_association_only fields
- reject mixed_workflows inside single form|page
- reject high_risk_assumptions
- output_syntax := inherited_contract_syntax
EXAMPLE_RULE:
- registration -> account_fields|profile_fields only
- job_application -> selected_job + applicant_info + resume
- registration.resume|job_title -> invalid unless signup.requires_applicant_profile_setup = true
OUTPUT_TO_PLAN:
- workflow_logic_checks|deferred_scope|assumptions|open_questions
