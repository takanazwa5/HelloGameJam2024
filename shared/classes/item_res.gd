class_name ItemRes extends Resource


enum Type {CLICKABLE, NON_CLICKABLE}


@export var display_name : String
@export var thumbnail : Texture2D
@export var icon : Texture2D
@export var type : Type = Type.CLICKABLE
