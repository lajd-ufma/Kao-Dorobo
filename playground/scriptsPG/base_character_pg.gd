extends CharacterBody2D
class_name BaseCaracter

@export_category("Variables")
@export var _move_speed := 250.0
@export var _dash_speed := 900.0
@export var _dash_time := 0.15

@export_category("Objects")
@export var _animation: AnimationPlayer
@export var _sprite2D: Sprite2D

@export_category("Combat")
@export var bullet_scene: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var raycast_l: RayCast2D = $raycast_l
@onready var raycast_r: RayCast2D = $raycast_r
#
#var idle_agua := preload("res://assets/agua/idle_mask_agua.png")
#var idle_side := preload("res://assets/agua/idle_left_agua.png")
#var idle_up := preload("res://assets/agua/idle_up_agua.png")
#
#var run_agua := preload("res://assets/agua/run_down_agua.png")
#var run_side := preload("res://assets/agua/run_left_agua.png")
#var run_up := preload("res://assets/agua/run_up_agua.png")
#
#var SPRITES_AGUA :={
	#"idle": idle_agua,
	#"idle_side": idle_side,
	#"idle_up": idle_up,
	#"run": run_agua,
	#"run_side": run_side,
	#"run_up": idle_up,
#}
##var SPRITES_AGUA :={
	##"idle": idle_agua,
	##"idle_side": idle_side,
	##"idle_up": idle_up,
	##"run": run_agua,
	##"run_side": run_side,
	##"run_up": idle_up,
##}
#var textures := {
	#"NONE": SPRITES_NONE,
	#"AGUA": SPRITES_AGUA
#}
#var actual_textures = textures["NONE"]

signal pegou_mascara
var mask_element := ""
var previous_mask := ""
var idle_animation := "idle"
var pode_empurrar_bloco := false
var pode_atirar := false
var pode_dar_dash := false
var last_direction := Vector2.DOWN

var is_dashing := false
var dash_timer := 0.0
var dash_direction := Vector2.ZERO

var is_mobile:= false
@onready var joystick: Control = $CanvasLayer/joystick
@onready var special: TouchScreenButton = $CanvasLayer/special

func _ready() -> void:
	pegou_mascara.connect(mudar_mask_element)
	_disactive_special_button()
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		is_mobile = true
	else:
		$CanvasLayer.queue_free()

func _active_special_button():
	if special != null:
		special.modulate = Color.WHITE
		special.visible = true

func _disactive_special_button():
	if special != null:
		special.modulate = Color.DARK_GRAY
		special.visible = false

func mudar_mask_element(element):
	previous_mask = mask_element
	mask_element = element
	match previous_mask:
		"AGUA":
			set_pode_entrar_na_agua(false)
		"VENTO":
			set_pode_empurrar_bloco(false)
		"SOMBRA":
			set_pode_dar_dash(false)
		"FOGO":
			set_pode_atirar(false)
	var tween_change_color:Tween = get_tree().create_tween()
	#
	#actual_textures = textures[mask_element]
	
	match mask_element:
		"AGUA":
			_disactive_special_button()
			tween_change_color.tween_property(self, "modulate", Color.ROYAL_BLUE, 1)
			set_pode_entrar_na_agua(true)
		"VENTO":
			_active_special_button()
			tween_change_color.tween_property(self, "modulate", Color.DARK_SEA_GREEN, 1)
			set_pode_empurrar_bloco(true)
		"SOMBRA":
			_active_special_button()
			tween_change_color.tween_property(self, "modulate", Color.MEDIUM_PURPLE, 1)
			set_pode_dar_dash(true)
		"FOGO":
			_active_special_button()
			tween_change_color.tween_property(self, "modulate", Color.DARK_ORANGE, 1)
			set_pode_atirar(true)

func _process(_delta: float) -> void:
	if raycast_l.is_colliding() or raycast_r.is_colliding():
		z_index=5
	else:
		z_index = 2
	set_animation()

func set_animation():
	var anim := idle_animation
	if velocity.x != 0:
		anim = "run_side"
		idle_animation = "idle_side"
	elif velocity.y > 0:
		anim = "run"
		idle_animation = "idle"
	elif velocity.y < 0:
		anim = "run_up"
		idle_animation = "idle_up"
	_animation.play(anim)

func set_pode_entrar_na_agua(value): 
	set_collision_mask_value(4, !value) 

func set_pode_empurrar_bloco(value): 
	pode_empurrar_bloco = value

func set_pode_dar_dash(value):
	pode_dar_dash = value

func set_pode_atirar(value):
	pode_atirar = value

func _input(event):
	if event.is_action_pressed("special"):
		if pode_atirar:
			shoot()
		if pode_dar_dash:
			start_dash()
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	if is_dashing:
		velocity = dash_direction * _dash_speed
		move_and_slide()
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			set_collision_mask_value(6, true)
		return

	var input_dir := Vector2.ZERO
	
	if is_mobile:
		input_dir = joystick.get_direction()
	else:
		input_dir.x = Input.get_axis("move_left", "move_right")
		input_dir.y = Input.get_axis("move_up", "move_down")

	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		last_direction = input_dir

	velocity = input_dir * _move_speed

	position.x = clamp(position.x, 0, 1280)
	position.y = clamp(position.y, 0, 768)

	move_and_slide()

	if velocity.x > 0:
		_sprite2D.flip_h = true
	elif velocity.x < 0:
		_sprite2D.flip_h = false

func start_dash() -> void:
	if is_dashing:
		return
	set_collision_mask_value(6, false)
	is_dashing = true
	dash_timer = _dash_time
	dash_direction = last_direction

func shoot() -> void:
	if bullet_scene == null:
		return
	if pode_atirar:
		pode_atirar = false
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.direction = last_direction
		get_parent().add_child(bullet)
		await get_tree().create_timer(0.5).timeout
		pode_atirar = true
