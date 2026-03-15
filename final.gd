extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.stop_music()
	$background_music.play()


func _on_button_quit_pressed() -> void:
	get_tree().quit()
