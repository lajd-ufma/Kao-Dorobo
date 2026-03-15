extends StaticBody2D

@onready var particles: CPUParticles2D = $CPUParticles2D

signal tomou_fogo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tomou_fogo.connect(queimar)
	
func queimar():
	particles.emitting = true
	set_collision_layer_value(8,false)
	$AnimationPlayer.play("burn")
	await get_tree().create_timer(7).timeout
	$AnimationPlayer.play_backwards("burn")
	particles.emitting = false
	set_collision_layer_value(8,true)
