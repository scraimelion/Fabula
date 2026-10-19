extends ColorRect

@onready var Continue = $VBoxContainer/AspectRatioContainer/TextureRect

var transitioning = false
var screen_opacity = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var opacity = (sin((Time.get_ticks_msec() - delta) / 500) + 1) / 2
	Continue.set_modulate(Color(1,1,1,opacity))
	
	if transitioning:
		screen_opacity -= 0.01
		self.set_modulate(Color(1,1,1,screen_opacity))
		if screen_opacity <= 0.0:
			self.visible = false
			Global.game_start = true


func _input(event: InputEvent) -> void:
	if (event.is_pressed()):
		transitioning = true
