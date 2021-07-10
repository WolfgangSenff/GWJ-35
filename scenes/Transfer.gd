extends Area2D

export (NodePath) onready var ToPositionPath
onready var _to_position = get_node(ToPositionPath)

func _on_Transfer_body_entered(body: Node) -> void:
    if body is Player and _to_position:
        body.set_physics_process(false)
        body.global_position = _to_position.global_position
        body.call_deferred("set_physics_process", true)
