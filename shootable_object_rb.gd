extends RigidBody2D

func _process(delta):
	if position.y > 100:
		GameLogic.damage_health(2.5)
		get_parent().queue_free()
