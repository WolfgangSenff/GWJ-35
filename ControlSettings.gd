extends Control

signal settings_updated

var use_pixel_font = true

onready var _anim = $AnimationPlayer

func swap_fonts() -> void:
    use_pixel_font = not use_pixel_font
    if use_pixel_font:
        _anim.play("UpdateFontDyslexic")
    else:
        _anim.play_backwards("UpdateFontDyslexic")
        
    yield(_anim, "animation_finished")
    emit_signal("settings_updated")
