# Database Implementation Rule
MODE: database_implementation

TRIGGER:
- task touches migration|schema|model|relationship|query|persistence

PREFLIGHT:
- inspect := existing_migrations|models|relationships|factories|seeders|queries|frontend_field_usage
- destructive_schema_change requires explicit_user_approval
- duplicate_column|duplicate_table := denied
- migration_rollback|migrate_reset|migrate_fresh|migrate_refresh := denied unless explicit_user_approval
- migration_down_method_with_data_loss -> require explicit_user_approval
- IF production_environment_detected -> destructive_migration_commands := denied

SCHEMA_CONTRACT:
- migration defines only current_task_required fields
- model_fields align with migration_columns
- relationships declare cardinality + foreign_keys + delete_behavior
- cascade_delete_on_required_relation := denied unless explicit_user_approval
- IF delete_behavior = cascade AND target_has_real_data -> stop_and_request_user_approval
- restrict|set_null preferred_over cascade unless explicitly planned
- indexes required for planned lookup/filter/sort paths
- nullable/defaults align with validation + UI optional fields

DATA_ALIGNMENT:
- db_field_to_frontend_name_map required before form/API edits
- API_json fields must_match model/migration names OR explicit adapter_mapping
- persistence_verified := create|read|update|delete as required by current task

FUNCTIONAL_DONE:
- schema supports current end_to_end user_flow
- persistence_or_query verified through route/service/UI path
- migration_only.as_checked := denied
