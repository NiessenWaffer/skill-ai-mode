# Page Design Rule
MODE: page_design_first
TARGET:
- inherit := Planning mode/Planning.md#LANGUAGE_POLICY
TRIGGER:
- request_type := user_facing_page|screen
- examples := homepage|landing_page|registration_page|form_page|listing_page|dashboard_page
OBJECTIVE:
- resolve page_value_contract before backend|database planning
PAGE_FORMULA:
- user_problem -> value_prop -> headline -> trust_signal -> CTA
PAGE_CONTRACT:
- identity := page_type|page_goal|target_user
- header := brand|nav|account_links|CTA|mobile_behavior
- hero := problem|value_prop|headline|trust_signal|primary_CTA|secondary_CTA
- visual_asset := frontend_image_layout|image_search_query|sample_image_value_source|brand_icon
- body := section_contracts|sidebar_if_required|footer
- interaction := clicks|forms|filters|modals|navigation|scroll_behavior|section_actions
- responsive := desktop_to_mobile_layout_delta
- exclusions := out_of_scope_sections|invalid_components
PAGE_INVARIANTS:
- first_viewport requires value_prop + CTA
- viewport_acquisition := TTFV <= 3s
- scroll_sequence := hook -> clarity -> trust_signal -> action
- component.supports one_of attention|clarity|trust_signal|action
- reject non_goal_aligned_components
- reject low_information_density_regions unless focus_gain = true
- backend_database_planning before page_value.resolved := denied
- interactive_section_without_action_contract := denied
- repeated_entity_card requires contextual_actions unless read_only_section = true

USER_COMPREHENSION_RULES:
- prefer_single_primary_message_per_section
- complex_aggregation with no user_visible_benefit := denied
- if aggregation is required -> show meaning via text|label|icon|example|empty_state_copy
- feature_text must explain how_user_uses_it
- icon must support meaning; icon_only without label := denied unless universally_clear
- non_technical_user_understanding := priority over compact_internal_structure
- avoid hidden_data_grouping unless it reduces confusion and is visible in UI copy
- section_content should read like a feature explanation, not an internal dataset

MOBILE_LAYOUT_RULES:
- mobile_priority := value_prop|primary_action|essential_inputs|critical_status|next_step
- section_order_on_mobile := most_important_user_task_first
- before_next_section -> confirm current_section.mobile_value_is_clear
- hide_desktop_only_content on mobile when it does not support current_task|required_state|core_action
- tables_on_mobile := convert_to_card|stacked_row|expandable_detail|horizontal_scroll_only_if_essential
- forms_on_mobile := single_column|minimal_labels|inline_help_when_needed|short_inputs|primary_button_near_bottom
- button_density_on_mobile := one_primary_action_per_viewport_preferred
- secondary_actions -> collapse_to_more_menu OR tertiary_link when clutter_risk exists
- section_with_low_mobile_value -> defer OR collapse
- mobile_section_completion requires clear_next_action before advancing
- if section cannot be understood on mobile without desktop context -> redesign the section

TOKEN_CONTRACT:
- typography_scale := max_3_global_text_styles
- tokens := font_families|colors|actions|borders|spacing
- colors := background|surface|text|muted_text|primary|secondary|danger|success
- actions := primary_button|secondary_button|link|disabled_state
- token_change propagates across UI_pattern
VISUAL_ASSET_CONTRACT:
- frontend_image_layout := slot|usage|aspect_ratio|object_fit|fallback_state|alt_intent
- image_search_query := app_domain + target_user + desired_visual_context
- sample_image_value_source := backend_or_seeders_resolve_url
- image_usage := hero_background|product_preview|section_visual|empty_state
- image_criteria := relevant|inspectable|non_generic|not_dark_blurred|supports_value_prop
- brand_icon := lettermark|monogram|simple_geometric_mark
- icon_text := 1..3 uppercase_letters
- icon_style := vector_ready|high_contrast|small_size_legible
VISUAL_ASSET_INVARIANTS:
- user_facing_page requires frontend_image_layout unless user_asset.exists OR visual_not_required = true
- image_slot_without_layout_spec := blocker
- sample_image_value_source required when entity has image_url field
- production_asset_replacement_required := true
- visual_asset_slot_empty_in_UI := denied
- image_url.source_note required when external_placeholder_not_owned
- reject emoji_icons|keyboard_symbols|checkmark_icons_as_brand
- reject icon_text.length > 3 unless user_approved
- prefer lettermark examples := VG|AI|CRM|PX
ACTION_CONTRACT:
- action := owner_section|target_entity|trigger_component|label_or_icon|action_type|destination|state_change|backend_contract|success_feedback|failure_state
- action_type := navigate|submit|create|update|delete|toggle|add|remove|share|filter|sort|compare|save
- contextual_actions := primary_action|required_secondary_actions|optional_actions
- repeated_entity_action_map := each card|row|list_item declares allowed_actions
- header_action_dependency := header_icon_or_link requires reachable section_action OR destination_route
- commerce_product_actions := view_details|add_to_cart|buy_now|wishlist|share when cart_or_checkout_or_sharing exists in scope
- actionless_button|dead_icon|decorative_control := denied
- action_visual := button|icon_button|link|menu|swipe_action|keyboard_action
- action_contract_missing -> not_ready_for_workflow

SECTION_CONTRACT:
- section := name|user_problem|value_solution|supporting_trust_signal|inclusion_rationale|content_contract|section_actions|entity_action_map|data_contract|state_contract
- headline_options := 2..3
- CTA_options := 1..2
- CTA_readiness_level := early_interest|commitment|task_completion|multi_step
HEADLINE_INVARIANTS:
- benefit_driven := true
- specificity := high
- maps_to := user_problem|desired_outcome
CTA_MAP:
- early_interest -> Explore|Learn More|View Options
- commitment -> Sign Up|Start|Create Account
- task_completion -> Apply|Book|Submit|Send
- multi_step -> Continue|Save|Review
DENYLIST:
- generic_headings := About Company|Information|Features
- random_sections_without_user_problem
- next_workflow_routing before page_structure.resolved
OUTPUT_TO_PLAN:
- page_screen_contracts
- section_action_contracts
- design_content_strategy
- visual_asset_strategy
- mobile_layout_strategy
- section_priority_order






