class_name Player
extends Node3D

var flecha = load("res://Models/flecha_petrificadora.tscn")
var instance

@onready var Camera = $PhantomCamera3D
@onready var Arco = $PhantomCamera3D/RayCast3D
@onready var arco_sound = $PhantomCamera3D/RayCast3D/AudioStreamPlayer3D
@onready var walk_sound = $PhantomCamera3D/AudioStreamPlayer3D

## Can we move around?
@export var can_move : bool = true
@export var rotate_accel : float = 0.003
@export var max_speed : float = 0.015
@export var bob_speed : float = 0.15
@export var max_height : float = 0.01

@export_group("Input Actions")
## Name of Input Action to move Left.
@export var input_left : String = "left"
## Name of Input Action to move Right.
@export var input_right : String = "right"
## Name of Input Action to Shoot.
@export var input_shoot : String = "jump"

@export_group("Shoot settings")
@export var min_fov : float = 60.0

var current_speed : float
var current_dir : float
var look_rotation : float
var progress : float
var current_height : float
var starting_fov : float
var current_fov : float
var shooting : bool
var shot_ready : bool
var shot_ready_sound_played : bool
var shoot : bool
var ding_sound
var draw_sound

# @onready var head: Node3D = $RotatePoint

func _ready() -> void:
	check_input_mappings()
	current_speed = 0
	look_rotation = rotation.y
	current_height = 0
	progress = 0
	starting_fov = Camera.camera_3d_resource.fov
	current_fov = starting_fov
	shooting = false
	shot_ready = false
	shot_ready_sound_played = false
	ding_sound = load("res://Sound/Bow/ready.mp3")
	draw_sound = load("res://Sound/Bow/draw_shortest.mp3")

func _process(_delta: float) -> void:
	

	walk_sound.stream_paused = true

	if not Global.game_start:
		return
				
	if not Global.is_archer:
		can_move = false
		Camera.priority = 0
	else:
		can_move = true
		Camera.priority = 1
	
	if not Global.can_move:
		can_move = false
	else:
		can_move = true

	var pressed_left := Input.is_action_pressed(input_left)
	var pressed_right := Input.is_action_pressed(input_right)

	if can_move and (pressed_left or pressed_right):
		walk_sound.stream_paused = false
		accelerate()
		if pressed_left:
			current_dir = -1.0
		if pressed_right:
			current_dir = 1.0
	else:
		decelerate()
		# TODO: hacer que pare el audio cuando esté pausado
		walk_sound.stream_paused = true

	look_rotation += current_speed * current_dir

	var speed_percent = current_speed / (max_speed / 1000)
	progress += bob_speed
	current_height = sin(progress) * max_height * speed_percent
	translate_object_local(Vector3(0,current_height,0))

	transform.basis = Basis()
	rotate_y(look_rotation)

	#SHOOTING
	if shooting:
		if current_fov > min_fov:
			current_fov -= 0.3
		elif shot_ready == false:
			shot_ready = true
		Camera.camera_3d_resource.fov = current_fov
	elif current_fov < starting_fov:
		current_fov += 6
		Camera.camera_3d_resource.fov = current_fov
	else:
		#arco_sound.playing = false
		can_move = true
	
	if shot_ready and not shot_ready_sound_played:
		arco_sound.stream = ding_sound
		arco_sound.playing = true
		shot_ready_sound_played = true

	if shoot:
		arco_sound.stream = draw_sound
		instance = flecha.instantiate()
		instance.position = Arco.global_position
		instance.transform.basis = Arco.global_transform.basis
		get_parent().add_child(instance)
		shoot = false
		shot_ready = false
		shot_ready_sound_played = false
	



func accelerate():
	if abs(current_speed) < max_speed / 1000:
		current_speed += rotate_accel / 1000
	else:
		current_speed = max_speed / 1000


func decelerate():
	if current_speed > 0 and current_speed > rotate_accel / 1000:
		current_speed -= rotate_accel / 1000
	elif current_speed < rotate_accel / 1000:
		current_speed += rotate_accel / 1000
	else:
		current_speed = 0


func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false
	   

func _input(event: InputEvent) -> void:
	if not Global.is_archer:
		return
	if event.is_action_pressed(input_shoot):
		arco_sound.playing = true

		can_move = false
		shooting = true

	if event.is_action_released(input_shoot):
		arco_sound.playing = false      
		if current_fov > min_fov:
			shooting = false
		else:
			shooting = false # quitar al implementar el disparo
			shoot = true
