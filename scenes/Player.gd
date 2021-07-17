class_name Player
extends KinematicBody2D

const Acceleration = 180
const Gravity = 550
const Friction = 250
const MaxSpeed = 120
const MaxWallKicks = 5
const JumpStrength = -190
const WindResistance = 50

var _kick_count = 0
var _velocity = Vector2.ZERO
var _previous_direction = Vector2.RIGHT
var _screen_size
var _was_in_air = true
var _last_animation = "IdleLeft"

onready var _sprite = $Sprite
onready var _anim = $AnimationPlayer
onready var _move_anim = $MovementAnimationPlayer
onready var _ledge_grab_cast = $LedgeGrabCast
onready var _footsteps_sound = $Sfx/Footsteps
onready var _landing_sound = $Sfx/Landing

func _ready() -> void:
    _screen_size = get_viewport_rect().size
    for child in $Sfx.get_children():
        child.volume_db = ControlSettings.sfx_volume

func _physics_process(delta: float) -> void:
    var h_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    var on_wall = is_on_wall()
    var on_wall_and_can_kick = on_wall and _kick_count < MaxWallKicks
    var on_floor = is_on_floor()
    var jumped = Input.is_action_just_pressed("jump") and (on_floor or on_wall_and_can_kick)
    if on_floor:
        _kick_count = 0
    
    _ledge_grab_cast.rotation_degrees = 0 if h_input == -1 else 180 if h_input == 1 else _ledge_grab_cast.rotation_degrees
    
    if sign(h_input) != sign(_previous_direction.x):
        _previous_direction.x = h_input
    
    if _was_in_air and on_floor:
        _was_in_air = false
        _landing_sound.play()
        
    if jumped:
        if on_wall_and_can_kick:
            _kick_count += 1
            _velocity.y = JumpStrength
            _play_left_right_anim("WallKick")
            _landing_sound.play()
        elif not on_wall and on_floor:
            _velocity.y = JumpStrength
            _play_left_right_anim("Jump")
        _was_in_air = true
    
    
    var h_input_not_zero = not is_zero_approx(h_input)
    
    if h_input_not_zero and on_floor:
        _velocity.x += h_input * Acceleration * delta
        _velocity.x = clamp(_velocity.x, -MaxSpeed, MaxSpeed)
        if not _move_anim.current_animation.begins_with("Jump"):
            _play_left_right_anim("Run")
    elif on_floor and not is_zero_approx(_velocity.x):
        _velocity.x = move_toward(_velocity.x, 0, delta * Friction)
        if not _move_anim.current_animation.begins_with("Jump"):
            _play_left_right_anim("Run")
    else:
        _velocity.x = move_toward(_velocity.x, 0, delta * WindResistance)
        
    _velocity.y += Gravity * delta
    var x_vel_zero = is_zero_approx(_velocity.x)
    if not x_vel_zero and on_floor and not jumped and not _footsteps_sound.playing:
        _footsteps_sound.play()
    if abs(_velocity.x) < 10.0 and on_floor and not jumped:
        _footsteps_sound.stop()
    if not on_floor:
        _footsteps_sound.stop()
        
    if x_vel_zero and not jumped and on_floor and not _move_anim.current_animation.begins_with("Idle"):
        _play_left_right_anim("Idle")
    
    _velocity.y = move_and_slide_with_snap(_velocity, Vector2.DOWN if not jumped or on_floor else Vector2.ZERO, Vector2.UP, true).y
    
    var should_slide = not jumped and on_floor and sign(_velocity.x) != sign(_previous_direction.x) and not is_zero_approx(_velocity.x) and h_input_not_zero and not is_zero_approx(_previous_direction.x)
    if should_slide:
        _play_left_right_anim("Slide")
    
    position.x = wrapf(position.x, 0, _screen_size.x)
    position.y = wrapf(position.y, 0, _screen_size.y)

func _play_left_right_anim(anim) -> void:
    var sign_x = sign(_velocity.x)
    var is_zero = is_zero_approx(_velocity.x)
    var lr = ("Right" if sign_x > 0 else "Left")
    var animation = anim + lr
    if is_zero and is_on_floor() and (not anim.begins_with("Jump")):
        lr = ("Right" if _last_animation.ends_with("Right") else "Left")
        _move_anim.play("Idle" + lr)
        _last_animation = "Idle" + lr
        return
    
    _move_anim.play(anim + lr)
    _last_animation = animation

func disable_physics(is_forward = true) -> void:
    set_physics_process(false)
    if abs(_velocity.y) > abs(_velocity.x):
        _sprite.material.set_shader_param("direction", Vector2(0, _velocity.y).normalized())
    else:
        _sprite.material.set_shader_param("direction", Vector2(_velocity.x, 0).normalized())
    _anim.play("Forward" if is_forward else "Backward")
    
func enable_physics() -> void:
    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")
    call_deferred("set_physics_process", true)
