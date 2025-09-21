extends CharacterBody2D


const hover_speed = 300.0
const plunge_speed = 1300.0
const JUMP_VELOCITY = -400.0
var min_wait = 1.0
var max_wait = 5.0
var canmove = false
#var delta = get_physics_process_delta_time()
@onready var character_body_2d: CharacterBody2D = $"../CharacterBody2D"
@onready var collision_shape_2d_2: CollisionShape2D = $CollisionShape2D2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_plunging = false

func _ready() -> void:
	start_waiting()
	
	
func start_hovering():
	# Add the gravity.
	var target_x = character_body_2d.global_position.x
	while canmove and abs(global_position.x - target_x) > 5:
		target_x = character_body_2d.global_position.x
		var direction = sign(target_x - global_position.x)
		velocity.x = direction * hover_speed
		velocity.y = 0
		move_and_slide()
		await get_tree().process_frame
		
		if direction:
			animated_sprite_2d.flip_h=false
		else: 
			animated_sprite_2d.flip_h= true
	canmove = false
	velocity.x = 0
	velocity.y = 0
	start_plunge()
	print("start plunge")

	
func start_waiting():
	canmove = false
	var waittime = randf_range(min_wait,max_wait)
	await get_tree().create_timer(waittime).timeout
	canmove = true
	print("can move")
	start_hovering()
	
func start_plunge():
	canmove = true
	velocity = Vector2(0, plunge_speed)

	while canmove:
		move_and_slide()
		var collision = get_last_slide_collision()
		if collision:
			var col = collision.get_collider()
			if col.is_in_group("Player"):
				print("Hit player!")
				break  # stop plunging if it hits the player
			else:
				print("Hit something else -> paralyzed")
				canmove = false
				velocity = Vector2.ZERO
				animated_sprite_2d.play("paralyzed")
				return
		await get_tree().process_frame

		# Reset after plunge
	is_plunging = false
	velocity = Vector2.ZERO
