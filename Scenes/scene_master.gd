extends Node


func _ready():
	var mainMenu = preload("res://Scenes/menu.tscn").instantiate()
	add_child(mainMenu)
