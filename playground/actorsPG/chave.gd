extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var portal:=get_tree().get_first_node_in_group("portal")
		if portal:
			portal.emit_signal("chave_coletada")
		queue_free()
