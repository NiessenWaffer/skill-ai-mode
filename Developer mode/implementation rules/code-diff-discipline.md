# Code Diff Discipline Rule
MODE: implementation_diff_discipline

LOAD_POLICY:
- must_read_when := pre_commit|pre_pr|pre_push|large_change_detected
- route := ../developer.md

RULES:
- prefer_small_commits := true
- each_commit := single_purpose + test_or_verification_note
- deny := unrelated_refactors_in_same_commit
- require := before_after_notes in task.md for non-trivial changes
- generate_patch_list := summarize changed files + rationale
- if large_change_detected -> split_by_vertical_slice and re-verify

OUTPUT:
- patch_list
- verification_notes
