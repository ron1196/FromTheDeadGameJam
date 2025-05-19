extends Node

var ui_layers_active := 0


func is_game_input_allowed() -> bool:
	return ui_layers_active == 0


func register_ui_layer():
	ui_layers_active += 1


func unregister_ui_layer():
	ui_layers_active = max(0, ui_layers_active - 1)


func convert_enum_to_string(input_map_options: Enums.InputMapOptions) -> String:
	match input_map_options:
		Enums.InputMapOptions.INPUT_OPEN_BUILDER:
			return Globals.INPUT_OPEN_BUILDER

	push_error("No matching string for enum option: " + str(input_map_options))

	return ""
