# Controls And Routing Implementation Rule
MODE: controls_routing_implementation

TRIGGER:
- task touches route|navigation|CTA|icon_button|dropdown|menu|dots|link|form_action|user_flow

PREFLIGHT:
- inspect := web_routes|api_routes|SPA_routes|controller_actions|page_components|nav_links|forms|api_clients
- framework_route_inventory := Laravel:routes/web.php|routes/api.php|app/Http/Controllers OR Vite:src/main.*|router_config|page_components OR detected_framework_equivalent

CONTROL_ROUTE_CONTRACT:
- control_flow := control -> handler_or_route -> validation_if_any -> state_change_or_navigation -> feedback
- each visible interactive control must have reachable target
- icon_button requires accessible_name + handler + feedback_state
- dropdown/menu/dots requires open_state + close_state + item_actions + outside_click_or_escape_behavior
- hover_state cannot substitute for click/focus behavior
- header_icon_or_link requires destination_route OR matching section_action
- repeated_entity_control_map := each card|row|list_item declares allowed_actions

ROUTING_CONTRACT:
- route_name|path|method must_match UI_links|forms|api_clients
- missing_in_scope_route -> implement route + controller_action + view_or_component wiring
- missing_out_of_scope_route -> request Planning mode revision
- orphan_CTA|dead_link|unhandled_form_submit|unreachable_controller := denied
- duplicate_route := denied

VERIFY:
- Laravel_verify := php artisan route:list when available; else static route_controller_scan
- SPA_verify := router_config + rendered_navigation + direct_url_refresh when feasible
- planned actions reachable: control -> route_or_handler -> state_change -> user_feedback
