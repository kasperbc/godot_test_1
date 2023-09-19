extends Node2D

@export var current_obj : Dictionary
@export var hovering_over_obj = false

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()

func shoot():
	if hovering_over_obj == true:
		current_obj.get("collider").get_parent().on_hit()
	else:
		GameLogic.on_miss()

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	
	# var query = PhysicsRayQueryParameters2D.create(mouse_pos + Vector2.UP * 200, mouse_pos)
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	var result = space_state.intersect_point(query)
	
	if result.size() == 0:
		hovering_over_obj = false
		return
	
	hovering_over_obj = true
	current_obj = result[0]
