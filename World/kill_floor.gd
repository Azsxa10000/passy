extends Area3D

# temporily just changes position of character body to position of temp respawn point
func _on_body_entered(body: Node3D) -> void:
	if body in get_tree().get_nodes_in_group("PlayerCharacterBody"):
		body.global_position = get_tree().get_first_node_in_group("RespawnPoint").global_position
