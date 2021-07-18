extends Area2D

func _on_Transfer_body_entered(body: Node) -> void:
	body.position.y = wrapf(body.position.y, 0, get_viewport_rect().size.y)
	get_tree().call_group("Game", "transfer_backward")
