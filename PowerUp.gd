class_name Gauntlets
extends Area2D

signal gauntlets_unlocked

onready var animation_player = $AnimationPlayer

func _on_PowerUp_body_entered(body: Node) -> void:
	animation_player.play("Got")
	yield(animation_player, "animation_finished")
	emit_signal("gauntlets_unlocked")
	$CollisionShape2D.disabled = true
