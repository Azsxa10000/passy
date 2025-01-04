class_name  DebugMenu
extends Control

@export var velocity_label : Label
@onready var player_character : BaseCharacter = get_tree().get_first_node_in_group("PlayerCharacterBody")


func update_velocity_label() -> void:
	if player_character.is_node_ready():
		velocity_label.text = str(
		"velocity = ", player_character.velocity , "\n",
		"length= ", player_character.velocity.length()
)


func _physics_process(delta: float) -> void:
	if visible:
		update_velocity_label()
