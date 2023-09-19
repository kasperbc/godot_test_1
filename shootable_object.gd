extends Node2D

@export var sprites : Array[CompressedTexture2D]
@onready var particle = preload("res://hit_particle.tscn")
func _ready():
	get_node("RigidBody2D/Sprite2D").texture = sprites.pick_random()

func on_hit():
	GameLogic.on_shootable_obj_hit()
	
	var part = particle.instantiate()
	part.global_position = get_node("RigidBody2D").global_position
	get_parent().add_child(part)
	part.get_node("GPUParticles2D").amount = randi_range(2, 5)
	part.get_node("GPUParticles2D").emitting = true
	
	part.get_node("SpriteHolder").rotation_degrees = randf_range(0, 360)
	
	get_parent().get_parent().get_node("Camera").screen_shake(0.5,0.5)
	queue_free()

