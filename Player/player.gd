extends CharacterBody2D

@export var air_friction = 0.6
@export var ground_friction = 0.1
@export var acceleration = 0.2
@export var speed = 200.0
@export var jump_speed = -322.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")

func _ready():
	pass
	
func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _physics_process(delta):
	# Add gravity
	self._apply_gravity(delta)

	# Handle jump
	if Input.is_action_just_pressed("press_jump") and is_on_floor():
		anim.play("Jump")
		velocity.y = jump_speed

	# Release jump
	if Input.is_action_just_released("press_jump") and velocity.y < 0:
		velocity.y = lerp(velocity.y, 0.0, air_friction)
		
	if velocity.y > 0:
		anim.play("Fall")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("press_left", "press_right")
	
	if direction < 0:
		sprite.flip_h = true
	if direction > 0:
		sprite.flip_h = false
		
		
	if direction:
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
		if velocity.y == 0:
			anim.play("Run")
	else:
		if velocity.y == 0:
			if is_equal_approx(velocity.x, 0.0):
				anim.play("Idle")
			if velocity.x > 0 or velocity.x < 0:
				anim.play("Skid")
				velocity.x = lerp(velocity.x, 0.0, ground_friction)
		else:
			velocity.x = lerp(velocity.x, 0.0, ground_friction)

	move_and_slide()
