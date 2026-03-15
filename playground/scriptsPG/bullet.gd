extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed := 350.0

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	queue_free()
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	rotation = direction.angle() + 3* PI / 2
func _on_body_entered(body: Node2D) -> void:
	animation_player.play("disappearing")
	direction = Vector2.ZERO
	if body.is_in_group("cipo"):
		body.emit_signal("tomou_fogo")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "disappearing":
		queue_free()
