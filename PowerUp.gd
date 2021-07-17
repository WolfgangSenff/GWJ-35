class_name Gauntlets
extends Area2D

onready var animation_player = $AnimationPlayer

func _on_body_entered(_body):
	animation_player.play("Got")
	_body.emit_signal("Unlock_Gauntlets")
