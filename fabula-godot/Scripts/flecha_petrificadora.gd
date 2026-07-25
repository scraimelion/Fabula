extends Node3D

const SPEED = 70.0

@onready var arrow = $MeshContainer
@onready var ray = $RayCast3D
@onready var sound = $AudioStreamPlayer

var velocity = Vector3()
var hit_sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector3(0, 10, -SPEED)
	sound.playing = true
	hit_sound = load("res://Sound/Bow/hit.mp3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity += Vector3(0, -0.1, 0)
	position += transform.basis * velocity * delta
	arrow.rotation.x = velocity.angle_to(Vector3(0 , 0, -1))
	
	if ray.is_colliding():
		arrow.visible = false
		sound.stream = hit_sound
		sound.playing = true
		if ray.get_collider().is_in_group("nube"):
			ray.get_collider().hit()
			await get_tree().create_timer(1.0).timeout
			queue_free()

func _on_timer_timeout() -> void:
	queue_free()
