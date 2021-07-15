extends Button

onready var _anim = $AnimationPlayer

func _ready() -> void:
    connect("pressed", self, "_on_font_changed", [], CONNECT_DEFERRED)
    
func _on_font_changed() -> void:
    ControlSettings.swap_fonts()
    if not ControlSettings.use_pixel_font:
        text = "FONT: PIXEL"
    else:
        text = "FONT: DYSLEXIC"
