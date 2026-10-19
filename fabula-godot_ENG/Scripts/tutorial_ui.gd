extends Control

@onready var archer_hud = $ArcherHUD/Tutorial
@onready var tutorial = $ArcherHUD/Tutorial
@onready var crosshair = $ArcherHUD/Crosshair
@onready var tutorial_anim = $ArcherHUD/AnimationPlayer

@export var speed = 0.01
@export var show_time = 300

var opacity = 0.0
var time = 0
var shown = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tutorial.set_modulate(Color(1, 1, 1, 0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_archer:
		archer_hud.set_visible(true)
		crosshair.set_modulate(Color(1, 1, 1, 1))
	else:
		archer_hud.set_visible(false)
		crosshair.set_modulate(Color(1, 1, 1, 0))
	
	if (Global.game_start) and not shown:
		tutorial_anim.play("tutorial_anim")
		shown = true
