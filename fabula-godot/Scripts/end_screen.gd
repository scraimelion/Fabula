extends ColorRect

@onready var Continue = $VBoxContainer/AspectRatioContainer/TextureRect
@onready var Credits1 = $VBoxContainer/Label
@onready var Credits2 = $VBoxContainer/Label2
@onready var Sound = $AudioStreamPlayer

var launch_credits = false
var sound_played = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.game_over:
		launch_credits = true
		
	if launch_credits and not sound_played:
		Sound.play()
		sound_played = true
	
	if launch_credits:

		self.visible = true
		Continue.set_modulate(Color(1,1,1,0))
		
		await get_tree().create_timer(1.0).timeout
		Credits1.visible = true
		await get_tree().create_timer(3.0).timeout
		Credits2.visible = true
		await get_tree().create_timer(2.0).timeout
		launch_credits = false
		Global.game_quit = true
		
	var opacity = (sin((Time.get_ticks_msec() - delta) / 500) + 1) / 2
	Continue.set_modulate(Color(1,1,1,opacity))

func _input(event: InputEvent) -> void:
	if (event.is_pressed() and Global.game_quit):
		get_tree().quit()
