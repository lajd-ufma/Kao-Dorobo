extends Area2D

@export var wall: StaticBody2D

func _on_body_entered(_body: Node2D) -> void:
	if wall == null:
		return
	wall.emit_signal("button_hold")

func _on_body_exited(_body: Node2D) -> void:
	if wall == null:
		print("parede nao adicionada")
		return
	wall.emit_signal("button_free")
