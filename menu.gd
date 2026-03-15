extends Control

func _ready() -> void:
	$AudioStreamPlayer.play()
	MusicManager.stop_music()
func _on_button_start_pressed() -> void:
	MusicManager.play_music()
	get_tree().change_scene_to_file("res://playground/scenesPG/level_1.tscn")
func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://controls.tscn")
