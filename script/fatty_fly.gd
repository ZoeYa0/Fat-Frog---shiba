extends Area2D

signal next_level_animation(next_level_path)

func _on_body_entered(_body: Node2D) -> void:
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	var next_level_path = "res://levels/level_" + str(next_level_number) + ".tscn"
	next_level_animation.emit(next_level_path)
	$Sprite2D.visible = false
	print("signal sent")
	
	
	
