extends Area2D

export (NodePath) onready var ToPositionPath

func _on_Transfer_body_entered(body: Node) -> void:
    var to_position = get_node(ToPositionPath)
    if body is Player and to_position:        
        body.set_physics_process(false)
        body.global_position = to_position.global_position
        body.call_deferred("set_physics_process", true)
