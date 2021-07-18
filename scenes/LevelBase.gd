extends Node2D

onready var _anim = $AnimationPlayer
onready var _tilemap1 = $TweenerLayer1
onready var _tilemap2 = $TweenerLayer2
onready var _tilemap3 = $TweenerLayer3
onready var _fg = $FG
onready var _sprite = $Sprite
onready var _tween = $Tween

var _expanded = false
var _disappeared = false
var _default_collision_layer1

func _ready() -> void:
	_default_collision_layer1 = _tilemap1.collision_layer
	_tilemap1.collision_layer = 0
	_tilemap2.collision_layer = 0
	_tilemap3.collision_layer = 0
	_fg.collision_layer = 0
	

func set_z_index_properly(index) -> void:
	z_index = -(index * 2)
	$FG.z_index = z_index + 2

func disable_physics() -> void:
	_tilemap1.collision_layer = 0
	_tilemap2.collision_layer = 0
	_tilemap3.collision_layer = 0
	_fg.collision_layer = 0
	
func enable_physics() -> void:
	_tilemap1.collision_layer = _default_collision_layer1
	_tilemap2.collision_layer = _default_collision_layer1
	_tilemap3.collision_layer = _default_collision_layer1
	_fg.collision_layer = _default_collision_layer1
	
func set_background_opacity(value) -> void:
	_tween.stop(_sprite, "self_modulate")
	var new_color = Color(0, 0, 0)
	new_color.r8 = 78
	new_color.g8 = 88
	new_color.b8 = 74
	new_color.a8 = 255 * value
	_tween.interpolate_property(_sprite, "self_modulate", _sprite.self_modulate, new_color, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.start()
	
func set_tweener_modulate(tweener, value) -> void:
	var node = get_node("TweenerLayer" + str(tweener))
	_tween.stop(node, "self_modulate")
	_tween.interpolate_property(node, "self_modulate", _sprite.self_modulate, value, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.start()

func set_scale(value) -> void:
	_tween.stop(self, "scale")
	_tween.interpolate_property(self, "scale", self.scale, value, 0.4, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	_tween.start()

func _on_Tween_tween_step(object: Object, key: NodePath, elapsed: float, value) -> void:
	if key == ":scale":
		object.global_position = Vector2(160.0, 98.0) * (1 - value.x)
