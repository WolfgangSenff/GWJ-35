extends BaseThemeableControl

onready var _tween = $Tween
onready var _current_screen = $MainContainer
onready var _lumiere = $Lumiere

const MainScreenX = 320

func _on_StartButton_pressed() -> void:
    get_tree().change_scene("res://scenes/Game.tscn")

func _on_OptionsButton_pressed() -> void:
    yield(move_to($OptionsContainer), "completed")
    
    
func _process(delta: float) -> void:
    _lumiere.global_position = get_global_mouse_position()
    
func move_to(node) -> void:
    _tween.stop_all()
    if _current_screen == $MainContainer:
        _tween.interpolate_property(_current_screen, "rect_scale", _current_screen.rect_scale, Vector2(3, 3), 0.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
        _tween.interpolate_property(node, "rect_scale", node.rect_scale, Vector2(1, 1), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        _tween.interpolate_property(_current_screen, "modulate", _current_screen.modulate, Color.transparent, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        _tween.start()
        yield(_tween, "tween_all_completed")
        _current_screen = node
    else:
        node.show()
        _tween.interpolate_property(_current_screen, "rect_scale", rect_scale, Vector2(0, 0), 0.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
        _tween.interpolate_property(node, "rect_scale", node.rect_scale, Vector2(1, 1), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        _tween.interpolate_property(node, "modulate", _current_screen.modulate, Color.white, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        _tween.start()
        yield(_tween, "tween_all_completed")        
        _current_screen = node

func _on_BackButton_pressed() -> void:
    yield(move_to($MainContainer), "completed")


func _on_Tween_tween_step(object: Object, key: NodePath, elapsed: float, value) -> void:
    if value is Vector2:
        object.rect_position = Vector2(160.0, 98.0) * (1 - value.x)
