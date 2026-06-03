# Plan Selection Rule
MODE: planning_plan_selection

LOAD_POLICY:
- must_read_when := selection_needed|related_plan_overlap|new_plan|revision
- route := ../Planning.md

RULES:
- read List plan/index.md -> gather existing plan{n}
- detect_overlap := title|feature|page|workflow_similarity
- IF strong_overlap -> propose reuse existing plan{n}
- ELSE -> allocate next sequence_id
- user_confirm_target := true
- link_context := update depends_on|connected_to (read-only proposal)
- ambiguous_selection -> ask_user and record rationale in plan.md:notes

OUTPUT:
- target_plan{n}
- selection_notes
