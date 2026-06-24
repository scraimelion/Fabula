extends CharacterBody3D

@onready var pivot = $CamOrigin
@onready var character_model = $chara_anims
@onready var animation_player = $chara_anims/AnimationPlayer
@onready var camera = $CamOrigin/SpringArm3D/PhantomCamera3D
@onready var timer = $Timer

@export var accel = 1.0
@export var max_speed = 8.0
@export var jump_velocity = 4.5
@export var sensibility = 0.5
@export var max_deg_up = -90
@export var max_deg_down = 45
@export var max_slope_angle = 45
@export var sway = 0.1

var running = false
var decel = false
var jumping = false
var resetting = false
var current_direction: Vector3
var max_direction: Vector3
var min_direction: Vector3

func _ready() -> void:
	set_floor_max_angle(deg_to_rad(max_slope_angle))
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Dialogic.signal_event.connect(_on_dialogic_signal)


# Revisar para controlador / para 
func _input(event: InputEvent) -> void:
	if Global.is_archer or not Global.can_move:
		return
	return
	if event is InputEventMouseMotion:
		print(event.relative.x)
		# Rotar sólo cámara si no se está corriendo, rotar todo jugador si se está corriendo
		var input_rotation_x = deg_to_rad(-event.relative.x * sensibility)
		if not running:
			pivot.rotate_y(input_rotation_x)
		else:
			rotate_y(input_rotation_x)
			#character_model.rotate_z(input_rotation_x)
			#print(input_rotation_x)
			
		pivot.rotate_object_local(Vector3.RIGHT, deg_to_rad(-event.relative.y * sensibility))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(max_deg_up), deg_to_rad(max_deg_down))

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		jumping = true
		if timer.is_stopped() and not resetting:
			print("CONTANDO")
			timer.start()
	else:
		jumping = false
		if not timer.is_stopped():
			timer.stop()
			print("PARANDO")
	
	
	# Ch
	if Global.is_archer or not Global.can_move:
		if Global.is_archer:
			camera.set_priority(0)
		else:
			camera.set_priority(1)
		animation_player.play("Idle")
		return
	
	#Process mouse
	var input_rotation_x = deg_to_rad(-Global.mouse_relative.x * sensibility)
	if not running:
		pivot.rotate_y(input_rotation_x)
	else:
		rotate_y(input_rotation_x)
		#character_model.rotate_z(input_rotation_x)
		#print(input_rotation_x)
		
	pivot.rotate_object_local(Vector3.RIGHT, deg_to_rad(-Global.mouse_relative.y * sensibility))
	pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(max_deg_up), deg_to_rad(max_deg_down))

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		# Si venimos de freecam, reestablecer la trans de la cámara, compensar en 
		if pivot.rotation.y != 0:
			rotation.y += pivot.rotation.y
			pivot.rotation.y = 0
		
		var angle = velocity.normalized().angle_to(direction)
		
		
		if rad_to_deg(angle) < 90:
			velocity += direction.normalized() * accel
			decel = false
		else:
			velocity += direction.normalized() * accel * 3
			decel = true
		character_model.look_at(position - Vector3(velocity.x,0,velocity.z))
		if rad_to_deg(angle) > 7:
			character_model.rotate_z(velocity.cross(direction).normalized().y *
									 angle * sway * 2)
		
		var velocity2D = Vector2(velocity.x, velocity.z)
		velocity.x = velocity2D.limit_length(max_speed).x
		velocity.z = velocity2D.limit_length(max_speed).y
	else:
		velocity.x = move_toward(velocity.x, 0, accel)
		velocity.z = move_toward(velocity.z, 0, accel)
		if velocity.length() > 0:
			decel = true
		else:
			decel = false
			character_model.rotation.z = 0
	
	#Process animations
	if velocity.length() > 0.0:
		running = true
		if decel:
			animation_player.play("Brake")
		elif jumping:
			animation_player.play("Fall")
		else:
			animation_player.play("Run", -1, 1.0)
	else:
		running = false
		animation_player.play("Idle")

	move_and_slide()

func _on_dialogic_signal(arg: String):
	match arg:
		"reset_pos":
			position = Vector3(-37.95, 2.263, -77.628)
			resetting = false
			pass

func _on_timer_timeout() -> void:
	resetting = true
	Dialogic.start("stuck_TL")
