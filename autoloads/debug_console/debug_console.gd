extends Control


var previous_mouse_mode : int

var history : Array[String] = []
var history_index : int = -1

var commands : Array[ConsoleCommand] = []

var autocomplete_index : int = 0
var last_input_was_autocomplete : bool = false
var previous_autocomplete_matches : PackedStringArray = []


func _ready() -> void:
	hide()

	visibility_changed.connect(on_visibility_changed)
	%Input.text_submitted.connect(on_input_text_submitted)

	create_command("help", help, "Displays available commands commands")
	create_command("clear", clear, "Clears console output")
	create_command("exit", exit, "Exits the console")
	create_command("quit", quit, "Quits the game")


func _input(event: InputEvent) -> void:
	if visible and not %Input.has_focus():
		%Input.grab_focus()

	if event is InputEventKey and event.pressed and not event.echo:

		if event.physical_keycode == KEY_QUOTELEFT:
			visible = not visible
			accept_event()

		elif event.physical_keycode == KEY_PAGEDOWN:
			%Output.get_v_scroll_bar().value += 494
			accept_event()

		elif event.physical_keycode == KEY_PAGEUP:
			%Output.get_v_scroll_bar().value -= 494
			accept_event()

		elif event.physical_keycode == KEY_UP:
			if history.is_empty() or not %Input.has_focus():
				return

			history_index = clampi(history_index + 1, 0, history.size() - 1)
			%Input.text = history[history_index]
			%Input.caret_column = %Input.text.length()
			accept_event()

		elif event.physical_keycode == KEY_DOWN:
			if history.is_empty() or not %Input.has_focus():
				return

			history_index = clampi(history_index - 1, 0, history.size() - 1)
			%Input.text = history[history_index]
			%Input.caret_column = %Input.text.length()
			accept_event()

		elif event.physical_keycode == KEY_TAB:
			if not %Input.has_focus():
				return

			autocomplete()
			accept_event()

		last_input_was_autocomplete = (
			Input.is_action_just_pressed("TAB")
			or Input.is_action_just_released("TAB")
		)


func on_visibility_changed() -> void:
	if visible:
		previous_mouse_mode = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(previous_mouse_mode)


func on_input_text_submitted(text: String) -> void:
	print_line("[b]> " + text + "[/b]")

	if text.is_empty():
		return

	%Input.text = ""
	history.push_front(text)
	if history.size() > 100:
		history.pop_back()
	history_index = -1

	var args : PackedStringArray = text.split(" ", false)

	if not has_command(args[0]):
		print_line("Command %s was not recognized" %args[0], Color.RED)
		return

	var command : ConsoleCommand = get_command(args[0])
	args.remove_at(0)

	var result : String = command.execute(args)

	if not result.is_empty():
		print_line(result)


func print_line(text: String, color: Color = Color.WHITE) -> void:
	%Output.push_color(color)
	%Output.append_text(text + "\n")
	%Output.pop()


func has_command(command: StringName) -> bool:
	for cmd : ConsoleCommand in commands:
		if cmd._command == command:
			return true
	return false


func get_command(command: StringName) -> ConsoleCommand:
	for cmd : ConsoleCommand in commands:
		if cmd._command == command:
			return cmd
	return null


func create_command(command: StringName, callable: Callable, description: String = "") -> void:
	commands.append(ConsoleCommand.new(command, callable, description))


func autocomplete() -> void:
	var matches : PackedStringArray = []

	if last_input_was_autocomplete:
		matches = previous_autocomplete_matches

	elif %Input.text.length() == 0:
		for command : ConsoleCommand in commands:
			matches.append(command._command)

	else:
		for command : ConsoleCommand in commands:
			if command._command.begins_with(%Input.text):
				matches.append(command._command)

	previous_autocomplete_matches = matches

	if matches.is_empty():
		return

	if last_input_was_autocomplete:
		autocomplete_index = wrapi(autocomplete_index + 1, 0, matches.size())

	else:
		autocomplete_index = 0

	%Input.text = matches[autocomplete_index]
	%Input.caret_column = %Input.text.length()


func help(command: StringName = "") -> void:
	if command == "":
		print_line("List of available commands:")
		for cmd : ConsoleCommand in commands:
			print_line("- " + cmd._command)
		return

	else:
		for cmd : ConsoleCommand in commands:

			if cmd._command == command:

				if cmd._description.is_empty():
					print_line("%s - No description" % cmd._command)

				else:
					print_line("%s - %s" % [cmd._command, cmd._description])

				var i : int = 0
				var required_args_count : int = cmd._args.size() - cmd._default_args.size()

				for arg : Dictionary in cmd._args:
					if i >= required_args_count:
						print_line("%s: %s (default = %s)" % [arg.name, type_string(arg.type),\
						cmd._default_args[-required_args_count + i]])

					else:
						print_line("%s: %s" % [arg.name, type_string(arg.type)])
					i += 1

				return

	print_line("Command %s was not recognized" % command)


func clear() -> void:
	%Output.clear()


func exit() -> void:
	visible = false


func quit() -> void:
	get_tree().quit()
