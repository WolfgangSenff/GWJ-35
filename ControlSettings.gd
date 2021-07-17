extends Control

signal settings_updated
signal sfx_volume_changed
signal music_volume_changed

var use_pixel_font = false
var sfx_volume = -10
var music_volume = -15

const MaxSoundVolume = -10

const SoundCutoffVolume = -50

onready var _main_music = $MainMusicPlayer
onready var _menu_music = $MenuMusicPlayer
onready var _anim = $AnimationPlayer

func swap_fonts() -> void:
    use_pixel_font = not use_pixel_font
    if use_pixel_font:
        _anim.play("UpdateFontDyslexic")
    else:
        _anim.play_backwards("UpdateFontDyslexic")
        
    yield(_anim, "animation_finished")
    emit_signal("settings_updated")
    
    
func adjust_sfx_volume(value) -> void:
    sfx_volume = value

func switch_to_menu() -> void:
    _main_music.stop()
    _menu_music.play()

func switch_to_game() -> void:
    _main_music.play()
    _menu_music.stop()

func adjust_music_volume(value) -> void:
    _main_music.volume_db = value
    _menu_music.volume_db = value
