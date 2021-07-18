extends Area2D

func _ready():
	yield(get_tree(), "idle_frame")
	z_index = get_parent().get_node("FG").z_index

func _on_EndDoor_body_entered(body: Node) -> void:
	if body.z_index == z_index - 2:
		get_tree().change_scene("res://scenes/Credits.tscn")
