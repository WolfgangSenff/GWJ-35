class_name Player
extends KinematicBody2D

const Acceleration = 180
const Gravity = 550
const Friction = 250
const MaxSpeed = 120
const MaxWallKicks = 1
const JumpStrength = -190
const WindResistance = 100

var _kick_count = 0
var _velocity = Vector2.ZERO

var _screen_size

onready var _sprite = $Sprite
onready var _anim = $AnimationPlayer
onready var _all_casts = [$CastRight, $CastLeft, $CastDown]

func _ready() -> void:
    _screen_size = get_viewport_rect().size

func _handle_raycasts() -> void:
    if collision_mask == 0:
        for cast in _all_casts:
            if cast.is_colliding():
                var collider = cast.get_collider()
                collision_mask = collider.collision_layer
                z_index = collider.z_index + 1
                break
            

func _physics_process(delta: float) -> void:
    _handle_raycasts()
    
    var h_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    var on_wall = is_on_wall()
    var on_wall_and_can_kick = on_wall and _kick_count < MaxWallKicks
    var on_floor = is_on_floor()
    var jumped = Input.is_action_just_pressed("jump") and (on_floor or on_wall_and_can_kick)
    if on_floor:
        _kick_count = 0
        
    if jumped:
        if on_wall_and_can_kick:
            _kick_count += 1
            _velocity.y = JumpStrength
        elif not on_wall and on_floor:
            _velocity.y = JumpStrength
        collision_mask = 0
    
    var h_input_not_zero = not is_zero_approx(h_input)
    
    if h_input_not_zero:
        _velocity.x += h_input * Acceleration * delta
        _velocity.x = clamp(_velocity.x, -MaxSpeed, MaxSpeed)
    elif on_floor:
        _velocity.x = move_toward(_velocity.x, 0, delta * Friction)
    else:
        _velocity.x = move_toward(_velocity.x, 0, delta * WindResistance)
        
    _velocity.y += Gravity * delta
    
    _velocity.y = move_and_slide_with_snap(_velocity, Vector2.DOWN if not jumped or on_floor else Vector2.ZERO, Vector2.UP, true).y
    
    position.x = wrapf(position.x, 0, _screen_size.x)
    position.y = wrapf(position.y, 0, _screen_size.y)

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
    yield(get_tree(), "idle_frame")
    call_deferred("set_physics_process", true)
