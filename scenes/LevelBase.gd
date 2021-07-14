extends Node2D

onready var _anim = $AnimationPlayer
onready var _tilemap = $TileMap
onready var _sprite = $Sprite
onready var _tween = $Tween

var _expanded = false
var _disappeared = false
var _default_collision_layer

func _ready() -> void:
    _default_collision_layer = _tilemap.collision_layer
    _tilemap.collision_layer = 0
    
func disable_physics() -> void:
    _tilemap.collision_layer = 0
    
func enable_physics() -> void:
    _tilemap.collision_layer = _default_collision_layer
    
func set_background_opacity(value) -> void:    
    _tween.stop(_sprite, "self_modulate")
    _tween.interpolate_property(_sprite, "self_modulate", _sprite.self_modulate, ColorN("black", value), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    _tween.start()

func set_scale(value) -> void:
    _tween.stop(self, "scale")
    _tween.interpolate_property(self, "scale", self.scale, value, 0.4, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
    _tween.start()

