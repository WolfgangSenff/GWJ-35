extends Control

onready var _scroll = $ScrollContainer
onready var _tween = $Tween
var _at_top = true

func _ready() -> void:
    while true:
        var current_scroll_vertical = _scroll.scroll_vertical
        var current_end_scroll = _scroll.get_v_scrollbar().max_value if _at_top else 0
        _tween.interpolate_property(_scroll, "scroll_vertical", current_scroll_vertical, current_end_scroll, 10, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
        _tween.start()
        yield(_tween, "tween_all_completed")
        _at_top = not _at_top
        current_end_scroll = _scroll.get_v_scrollbar().max_value if _at_top else 0
        _tween.interpolate_property(_scroll, "scroll_vertical", current_scroll_vertical, current_end_scroll, 10, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
        _tween.start()
        yield(_tween, "tween_all_completed")
        _at_top = not _at_top
        
