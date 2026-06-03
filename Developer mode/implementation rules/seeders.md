# Seeders Implementation Rule
MODE: seeders_implementation

TRIGGER:
- task touches sample_data|seeder|factory|fixture|mock_data|demo_state|list_UI

PREFLIGHT:
- inspect := existing_seeders|factories|fixtures|models|relationships|image_fields|UI_states
- one_sample_record_only := denied unless singleton_entity OR user_explicit_request

SAMPLE_DATA_CONTRACT:
- location := framework_seeders|factories|fixtures|mock_data
- migration_file_schema_only unless framework_requires_inline_seed
- minimum_records_per_primary_entity := 5..12 OR domain_required_count
- relationship_coverage := each_required_relation has linked_records
- state_coverage := domain_status_variants + empty/edge states required by UI
- value_coverage := low|medium|high numeric_ranges + short|long text_lengths + missing_optional_fields
- UI_coverage := enough_records_for list_grid|pagination|filters|sorting|empty_state|detail_page
- sample_image_fields require sourced renderable external_image_url + source_note
- image_url_source := search_or_select_relevant_source_for_UI_value
- empty_image_value := denied when UI displays image
- fake_data := non_sensitive + realistic + schema_valid
- seed_idempotency := rerunnable_without_duplicate_explosion REQUIRED
- IF !framework_native_idempotency -> upsert_pattern OR check_exists_before_insert OR explicit_user_approval_before_seed_rerun
- seeder_truncate_before_insert := denied unless explicit_user_approval
- seeder_run_against_production := denied
- IF seed_data_loss_risk_detected -> stop_and_request_user_approval

FUNCTIONAL_DONE:
- seeded_data renders through current UI/API path
- sample_data matches migration|model|validation|UI_required_fields
- seed_only.as_checked := denied unless task explicitly asks only for seed fixture


