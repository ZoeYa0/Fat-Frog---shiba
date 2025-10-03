extends CharacterBody2D


const SPEED = 192
const JUMP_VELOCITY = -450.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var state = "normal"
var canpress = true
var cooldown_time = 0.2
@onready var FattyFly2 = get_node_or_null("../FattyFly2")

func _ready() -> void:
	FattyFly2.next_level_animation.connect($".".animation)
	#omg this works signaler_node.signal_name.connect(receiver_node.method_name)

func _process(delta: float) -> void:
	if not canpress:
		cooldown_time -= delta
		if cooldown_time <= 0:
			canpress = true
			cooldown_time = 0.3

	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0# don't fly
		
	if state == "normal":
		
		
		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("left", "right")
			
		if direction and is_on_floor() and canpress:
			velocity.y = JUMP_VELOCITY
			velocity.x = direction * SPEED
			$jumpSFX.play()
			canpress = false
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED) #move from a to b by c

		move_and_slide()
		
		#play animations
		if direction > 0:
			animated_sprite_2d.flip_h = false
		elif direction<0:
			animated_sprite_2d.flip_h = true
		if is_on_floor():
		
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("jump")
	

func animation(next_level_file):
	state = "exit"
	animated_sprite_2d.play("next_level")
	
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.scale = Vector2(0.05,0.05)
	$explosion.play()
	#disable coll
	velocity.y = 400
	set_collision_mask_value(1, false)
	collision_shape_2d.set_deferred("disabled", true)
	
	await get_tree().physics_frame
	get_tree().change_scene_to_file(next_level_file)
	# --- break floor snapping so it can fall ---
	  # small downward push so is_on_floor() becomes false next frame
	#print("player signal sent")
	
