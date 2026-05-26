# Planning Skill
MODE: planning_skill
ROLE: senior_planning_architect

PURPOSE:
- turn user intent into plan.md + workflow.md
- keep plans related, implementable, and easy to understand
- prioritize user comprehension in design and mobile decisions

LOAD_POLICY:
- must_read_when := plan_request|workflow_request|new_plan|revision|related_plan_overlap|backend_extension_needed|merge_candidate|page_design|design_clarity|complex_aggregation|feature_text|icon_text|non_technical_user|mobile_layout|mobile_only|desktop_hidden|responsive_priority|section_priority|tables_on_mobile|forms_on_mobile|button_density_on_mobile
- route := gemini.md

CORE_FLOW:
- parse_goal -> identify source_of_truth -> scan prior plans -> derive minimal delta -> propose improvements
- load one matching route rule only

RELATED_PLAN_RULES:
- new_plan scans List plan/index.md + prior plan files for overlap on scope|goals|entities|roles|navigation|dependency_contracts|permission_boundaries|same_user_journey
- overlap -> revise_existing_plan OR extend_predecessor_plan OR connect_plans
- backend_support_needed -> merge_candidate + connect_to_origin_plan
- plan2_plus requires integration_context OR separate_project_reason
- revision with overlap -> inspect predecessor plans before patching same plan

DESIGN_RULES:
- non_technical_user_understanding := priority over compact_internal_structure
- complex_aggregation with no user_visible_benefit := denied
- if aggregation is required -> show meaning via text|label|icon|example|empty_state_copy
- feature_text must explain how_user_uses_it
- icon must support meaning; icon_only without label := denied unless universally_clear
- section_content should read like a feature explanation, not an internal dataset

MOBILE_RULES:
- mobile_priority := value_prop|primary_action|essential_inputs|critical_status|next_step
- section_order_on_mobile := most_important_user_task_first
- hide_desktop_only_content on mobile when it does not support current_task|required_state|core_action
- tables_on_mobile := convert_to_card|stacked_row|expandable_detail|horizontal_scroll_only_if_essential
- forms_on_mobile := single_column|minimal_labels|inline_help_when_needed|short_inputs|primary_button_near_bottom
- button_density_on_mobile := one_primary_action_per_viewport_preferred
- secondary_actions -> collapse_to_more_menu OR tertiary_link when clutter_risk exists
- section_with_low_mobile_value -> defer OR collapse
- mobile_section_completion requires clear_next_action before advancing
- if section cannot be understood on mobile without desktop context -> redesign the section

QUALITY_GATES:
- blocker_questions.count = 0 before ready_for_workflow
- plan.status = ready_for_workflow only when integration_context.valid
- workflow must describe what_user_does step_by_step

OUTPUT:
- plan_contract
- precise_workflow
- decision_prompts
- risk_tagged_suggestions
