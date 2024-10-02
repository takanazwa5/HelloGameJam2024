class_name ItemRes extends Resource


enum Type {PASSIVE, USABLE}


@export var scene : PackedScene
@export var display_name : String
@export var thumbnail : Texture2D
@export var icon : Texture2D
@export var type : Type = Type.USABLE
