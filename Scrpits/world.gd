extends Node3D


signal Get_Charecter





func _on_get_charecter() -> void:
	var player := preload("res://player/character.tscn").instantiate()
	add_child(player)
