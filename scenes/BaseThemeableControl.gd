class_name BaseThemeableControl
extends Control

func _ready() -> void:
    theme = ControlSettings.theme
    ControlSettings.connect("settings_updated", self, "_on_settings_changed", [], CONNECT_DEFERRED)
    
func _on_settings_changed() -> void:
    theme = ControlSettings.theme
