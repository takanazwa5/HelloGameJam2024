extends Node


var player : Player
var main : Main
var main_camera : Camera3D
var bathroom_camera : Camera3D
var inventory : Inventory

var item_in_hand : ItemRes = null
var item_slot : InventorySlot = null

var current_interaction_area : Area3D

var fridge : Fridge
var fridge_camera : Camera3D

var cupboard_shelves : Array[CupboardShelves]
var cupboard_shelves_camera : Camera3D
