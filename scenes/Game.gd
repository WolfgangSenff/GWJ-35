extends Node2D

const TransferTime = 0.4
const TransferSpeed = 1.0

onready var _current_layer = $LevelBase3
onready var _player = $Player
onready var _lumiere = $Lumiere

var _current_layer_index = 2
var _all_levels
var _level_size
var _transferring = false
var _current_transfer_time = 0

func _ready() -> void:
    _all_levels = get_tree().get_nodes_in_group("Level")
    reset_levels()
    _level_size = _all_levels.size()


func _process(delta: float) -> void:
    _lumiere.global_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
    if not _transferring:
        if Input.is_action_just_pressed("transfer_forward"):
            _current_layer_index -= 1
            _current_layer_index = clamp(_current_layer_index, 0, _level_size)
            if _current_layer_index >= 0:
                _player.disable_physics()
                reset_levels()
                _current_layer = _all_levels[_current_layer_index]
                _transferring = true
                _current_transfer_time = 0            
        elif Input.is_action_just_pressed("transfer_back"):
            _current_layer_index += 1
            _current_layer_index = clamp(_current_layer_index, 0, _level_size)
            if _current_layer_index < _level_size:
                _player.disable_physics(false)
                reset_levels()
                _current_layer = _all_levels[_current_layer_index]
                _transferring = true
                _current_transfer_time = 0
    else:
        _current_transfer_time += delta * TransferSpeed
        if _current_transfer_time > TransferTime:
            _transferring = false
            _player.enable_physics()

func reset_levels() -> void:
    var current_index = 0
    for level in _all_levels:
        if _current_layer_index == current_index:
            level.visible = true
            level.enable_physics()
            level.set_background_opacity(0)
            level.set_scale(Vector2(1.0, 1.0))
        elif _current_layer_index == current_index + 1:
            level.visible = true
            level.disable_physics()
            level.set_background_opacity(.7)
            level.set_scale(Vector2(.9, .9))
        elif _current_layer_index < current_index:
            level.disable_physics()
            level.set_scale(Vector2(1.4, 1.4))
            yield(get_tree().create_timer(0.2), "timeout")
            level.visible = false
        else:
            level.visible = true
            level.disable_physics()
            level.set_background_opacity(.9)
            level.set_scale(Vector2(.7, .7))
        
        current_index += 1
