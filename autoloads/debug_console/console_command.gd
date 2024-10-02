class_name ConsoleCommand extends RefCounted


var command : StringName
var description : String

var callable : Callable
var args : Array[Dictionary]
var default_args : Array


func _init(p_command: StringName, p_callable: Callable, p_description: String) -> void:
	command = p_command
	description = p_description
	callable = p_callable
	_init_args(p_callable.get_object())


func _init_args(p_object: Object) -> void:
	var method_list : Array[Dictionary] = p_object.get_script().get_script_method_list()
	for method : Dictionary in method_list:
		if method.name == callable.get_method():
			for arg : Dictionary in method.args:
				args.append({"name": arg.name, "type": arg.type})
			default_args = method.default_args
			return


func execute(p_args: PackedStringArray) -> String:
	var required_args_count : int = args.size() - default_args.size()

	if p_args.size() < required_args_count or p_args.size() > args.size():

		if default_args.size() == 0:
			var s : String = "[color=red]Expected %s arguments, received %s[/color]"
			return s % [required_args_count, p_args.size()]

		else:
			var s : String = "[color=red]Expected at least %s of %s arguments, received %s[/color]"
			return s % [required_args_count, args.size(), p_args.size()]

	var result : Variant

	if args.size() == 0:
		result = callable.call()

	else:
		var converted_args : Array
		for i : int in p_args.size():
			converted_args.append(type_convert(p_args[i], args[i].type))

			if converted_args[i] == null:
				var s : String = "[color=red]Cannot convert argument %s from String to %s[/color]"
				return s % [i + 1, type_string(args[i].type)]

		result = callable.callv(converted_args)

	return str(result) if not result == null else ""
