# Root Router

MODE: root_router

MODES:
- planning := Planning mode/planning-skill.md
- developer := Developer mode/developer-skill.md

AGENT_SKILLS:
- planning_skill := /planning -> Planning mode/planning-skill.md
- developer_skill := /developer -> Developer mode/developer-skill.md
- one_mode_at_a_time := true
- mode_switch_requires := explicit_user_request OR escalation_event

COMMAND_ALIASES:
- /planning -> planning
- /developer -> developer
- plan|spec|workflow|revise_plan -> planning
- implement|build|code|fix|task -> developer

COMMON_LANGUAGE_POLICY:
- syntax := compact_technical_contract
- units := labels|enums|predicates|IF_THEN|arrows|tables|checkboxes
- prose := chat_only; artifact_prose := rationale_notes_only
- avoid := filler|essays|synonym_drift|motivational_closure|ambiguous_plaintext
- decisions := approve|reject|revise|freeze_scope|begin_implementation

COMMON_REASONING_POLICY:
- source_required := true
- default_ai_behavior|infer_without_source|hidden_scope_change|unplanned_feature := denied
- mode_boundary_violation -> stop_and_route_to_owner

ARTIFACT_CONTRACT:
- store := List plan/; index := List plan/index.md; unit := List plan/plan{n}/
- files := plan.md|workflow.md|task.md
- plan_workflow_required_for_handoff := true
- task.md := developer_generated_from plan.md + workflow.md before code
- empty_task_file_allowed_until := developer_task_generation
- sequence_id := smallest_missing_positive_integer; sequence_gap := denied
- artifact_unit := one_major_page OR one_user_workflow OR one_bounded_feature
- semantics := plan.md:root_blueprint | workflow.md:precise_user_flow | task.md:developer_implementation_checklist
- duplicate_blueprint_files := denied

OWNERSHIP_MATRIX:
- planning_owns := plan.md.structure|workflow.md.structure|Planning mode/rules/*.md
- developer_owns := task.md.structure|task.md.execution_state|codebase_changes|Developer mode/implementation rules/*.md
- task.md.execution_state := check_state|blocked_state|verification_notes|implementation_notes

MODE_ROUTING:
- planning_request -> load planning only
- implementation_request -> load developer only
- mixed_request -> ask user choose planning|developer
- planning_complete -> ask user before developer handoff
- implementation_request.requires := approved plan.md + workflow.md
- developer.task_generation_required := true before implementation
- developer.planning_delta -> route_to_owner(planning)

ESCALATION_EVENT:
- trigger := revise|refactor|change|add_feature against plan.md|workflow.md|scope|requirements|UX_contract|backend_contract|data_contract
- active_mode = developer AND trigger -> stop_implementation
- route := Planning mode/Planning.md
- payload := requested_delta + affected plan{n}
- resume_gate := planning_coherent AND user_decision = begin_implementation

READ_POLICY:
- active_mode_instruction_only := true
- shared_artifacts.readable_by := planning|developer
- unrelated_mode_files := skip
- same_system_unrelated_artifacts := canonical_terms_only
- connected_artifacts := read when connection.read_required = true

HANDOFF_POLICY:
- planning_output := List plan/plan{n}/plan.md + workflow.md
- developer_input := same plan.md + workflow.md, no copy
- developer_generates := List plan/plan{n}/task.md
- developer_start_requires := plan.md.exists AND workflow.md.exists AND user_approved
- root_router_auto_enter_developer := denied
