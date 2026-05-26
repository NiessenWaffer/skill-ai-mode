# Runtime Safety Rule
MODE: implementation_runtime_safety

LOAD_POLICY:
- must_read_when := runtime_risk|env_change|dependency_install|config_change|preflight
- route := ../developer.md

TARGET:
- inherit := ../../gemini.md#COMMON_REASONING_POLICY
PURPOSE:
- safe_code_change
- state_inspection
RULES:
- inspect_existing_state first
- inspect := package_manifest|lockfile|env_files_presence|vite_config|entrypoints|router_config|api_clients|routes|controllers|migrations|models|schemas|forms|seeders|factories|fixtures|tests
- env_file_delete|overwrite|recreate := denied
- env_read_scope := filenames + key_names only
- env_secret_print := denied
- dependency_install requires package_absent AND manifest_entry_absent AND lock_entry_absent AND explicit_user_approval
- existing_dependency -> reuse_installed_version; reinstall := denied
- package_manager := detect_from lockfile; mixed_package_manager := denied unless user_approved
- existing_config_file -> patch_minimal_delta; full_replace := denied unless explicit_user_request
OUTPUT:
- risk_notes
- implementation_notes
