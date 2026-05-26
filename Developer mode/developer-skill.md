# Developer Skill
MODE: developer_skill
ROLE: senior_implementation_engineer

PURPOSE:
- turn approved plan.md + workflow.md into task.md and code
- keep implementation aligned with the plan
- implement mobile designs in a way that matches user comprehension and section priority

LOAD_POLICY:
- must_read_when := plan_delta|workflow_delta|task_scope_setup|runtime_risk|alignment_gap|checked_state_change|verification_stage|approval_gate|confusing_redirect|external_handoff|clarity_risk|report_generation
- route := gemini.md

CORE_FLOW:
- load plan.md + workflow.md -> generate_or_patch task.md -> pick one unchecked task -> implement -> verify -> report
- frontend first
- one current task at a time

TASK_RULES:
- task.md derives from plan.md + workflow.md
- task_generation_required_before_code := true
- missing_plan_or_workflow -> request Planning mode output first
- planning_delta|scope_change|blueprint_gap -> route back to planning
- do_not_implement_requested_change_from_memory := true

RUNTIME_RULES:
- inspect existing state before change
- runtime_risk -> check manifest|lockfile|env_files|entrypoints|routes|controllers|tests|config
- dependency_install requires package_absent AND manifest_entry_absent AND lock_entry_absent AND explicit_user_approval
- existing_config_file -> patch minimal delta; full_replace := denied unless explicit_user_request

ALIGNMENT_RULES:
- planned_action_contract required for interactive UI controls
- route_alignment := UI_controls + routes + handlers + state_changes
- data_alignment := migration + model + validation + API + frontend_payload + UI_state + seed_data
- naming_mismatch -> add_adapter_mapping OR route back to planning when contract_change_needed
- mobile implementation should respect the planned section order and mobile_priority from the plan
- tables_on_mobile -> card|stacked_row|expandable_detail|horizontal_scroll_only_if_essential
- forms_on_mobile -> single_column|minimal_labels|inline_help_when_needed|short_inputs|primary_button_near_bottom
- desktop_only_content should be hidden on mobile when it does not support the current task
- keep one primary action per viewport whenever possible

APPROVAL_RULES:
- approval_gate requires user_visible_reason|progress_state|next_step_text
- approval_gate cannot block core_user_value_path unless justification is explicit AND user_visible
- external_handoff or redirect_to_other_system requires explicit user_choice_text AND return_path
- if approval_flow blocks the primary action path without explanation -> mark clarity_risk

TASK_STATE_RULES:
- writable_fields := task_structure|check_state|blocked_state|verification_notes|implementation_notes
- check_state.blocked requires blocker_reason
- preserve checked work unless upstream_delta OR bug_evidence

VERIFICATION_RULES:
- verify functional result after implementation
- report concise execution summary with files_changed, verification_run, unverified_items, blocked_items

OUTPUT:
- current_task
- functional_result
- verification_run
- report
