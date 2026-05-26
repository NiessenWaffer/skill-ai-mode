# Backend Implementation Rule
MODE: backend_implementation

TRIGGER:
- task touches API|controller|service|validation|auth|business_logic|response_shape

PREFLIGHT:
- inspect := routes|controllers|services|middleware|validators|models|policies|existing_response_patterns
- duplicate_endpoint := denied
- orphan_controller_method := denied

IMAGE_VALUE_CONTRACT:
- backend may source renderable sample image URLs for API/entity image fields
- image_url_value requires source_url + source_note + render_check
- empty_image_value := denied when UI image field required

BACKEND_CONTRACT:
- request_contract := method|path|params|body|auth|validation
- handler_contract := route -> controller_action -> service_or_domain_logic
- response_contract := status_code|json_or_view_shape|error_shape
- side_effect_contract := persistence|session|event|notification|external_call
- validation_failure returns usable error feedback

ALIGNMENT:
- backend_response_shape must_match frontend_consumption
- frontend_submit_payload must_match backend_validation
- auth_permission_rule must_match plan.roles_permissions
- business_rule_change without plan support -> request Planning mode revision

FUNCTIONAL_DONE:
- callable_route reaches handler
- handler executes domain_logic
- success + failure paths observable
- backend_layer_only.as_checked := denied


