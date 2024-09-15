class_name ConsoleCommand extends RefCounted


var _command : StringName
var _description : String

var _callable : Callable
var _args : Array[Dictionary]
var _default_args : Array


func _init(command: StringName, callable: Callable, description: String) -> void:
	_command = command
	_description = description
	_callable = callable
	_init_args(callable.get_object())


func _init_args(object: Object) -> void:
	var method_list : Array[Dictionary] = object.get_script().get_script_method_list()
	for method : Dictionary in method_list:
		if method.name == _callable.get_method():
			for arg : Dictionary in method.args:
				_args.append({"name": arg.name, "type": arg.type})
			_default_args = method.default_args
			return


func execute(args: PackedStringArray) -> String:
	var required_args_count : int = _args.size() - _default_args.size()

	if args.size() < required_args_count or args.size() > _args.size():

		if _default_args.size() == 0:
			var s : String = "[color=red]Expected %s arguments, received %s[/color]"
			return s % [required_args_count, args.size()]

		else:
			var s : String = "[color=red]Expected at least %s of %s arguments, received %s[/color]"
			return s % [required_args_count, _args.size(), args.size()]

	var result : Variant

	if _args.size() == 0:
		result = _callable.call()

	else:
		var converted_args : Array
		for i : int in args.size():
			converted_args.append(type_convert(args[i], _args[i].type))

			if converted_args[i] == null:
				var s : String = "[color=red]Cannot convert argument %s from String to %s[/color]"
				return s % [i + 1, type_string(_args[i].type)]

		result = _callable.callv(converted_args)

	return str(result) if not result == null else ""
