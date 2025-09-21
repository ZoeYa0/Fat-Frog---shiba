extends Area2D

@onready var timer: Timer = $Timer
var scenechange = false
var file


func _on_body_entered(body: Node2D) -> void:
	if scenechange:
		get_tree().change_scene_to_file(file)
		print("scene changed")
	else:
		print("you died")
		Engine.time_scale = 0.5
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
	


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _ready() -> void:
	pass
	#$"../CharacterBody2D".falling.connect($".".next_level)

func next_level(next_level_file):
	scenechange = true
	file = next_level_file
	
	
