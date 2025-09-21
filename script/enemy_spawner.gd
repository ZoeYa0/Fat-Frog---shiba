# EnemySpawner.gd
extends Node2D

@export var spawn_interval: float = 2.0
@export var max_enemies: int = 10
@onready var spawn_area: CollisionShape2D = $Area2D/CollisionShape2D
@onready var enemy_scene: CharacterBody2D = $bird

var _spawned_enemies: Array = []

func _ready():
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if _spawned_enemies.size() >= max_enemies:
		return
	
	if enemy_scene and spawn_area.shape:
		var enemy = enemy_scene.instantiate()
		get_parent().add_child(enemy) # spawn in parent scene (world)
		enemy.global_position = global_position + _get_random_point_in_area()
		_spawned_enemies.append(enemy)

		enemy.tree_exited.connect(func():
			_spawned_enemies.erase(enemy))

func _get_random_point_in_area() -> Vector2:
	var rect = spawn_area.shape.get_rect()
	var x = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var y = randf_range(rect.position.y, rect.position.y + rect.size.y)
	return Vector2(x, y)
