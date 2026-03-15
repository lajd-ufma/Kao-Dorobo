extends Label

@onready var player: BaseCaracter = $"../../player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.pegou_mascara.connect(mudar_texto)
func mudar_texto(_mask_element):
	print("chegou aqui bb")
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		text = "Pressione o botão para utilizar o especial"
	else:
		text = "Pressione J ou Space para utilizar o especial"
