extends Node

func _ready() -> void:
    for child in get_children():
        child.volume_db = ControlSettings.sfx_volume
