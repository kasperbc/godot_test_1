extends Node2D

@onready var shootable_object = preload("res://shootable_object.tscn")

@export var GRAVITY_SCALE_MINMAX : Array[float] = [0.5, 1.0]
@export var GRAVITY_VARIANCE = 0.1
@export var LAUNCH_FORCE_MINMAX : Array[Vector2] = [Vector2(0.5,0.675), Vector2(0.5,1.0)]
@export var LAUNCH_FORCE_VARIANCE : Vector2 = Vector2(0.1,0.1)
	
func spawn_object():
	if GameLogic.dead:
		return
	
	var obj = shootable_object.instantiate()
	add_child(obj)
	
	var spawn_pos = Vector2((randf() * 240.0) - 120.0,90)
	obj.set_position(spawn_pos)
	
	# calculate launch force + gravity scale
	var grav_scale = GRAVITY_SCALE_MINMAX[0] + ((GRAVITY_SCALE_MINMAX[1] - GRAVITY_SCALE_MINMAX[0])  * (GameLogic.get_game_speed() - 1))
	var laun_force = LAUNCH_FORCE_MINMAX[0] + ((LAUNCH_FORCE_MINMAX[1] - LAUNCH_FORCE_MINMAX[0]) * (GameLogic.get_game_speed() - 1))
	
	# rigidbody stuffs
	var rb2d : RigidBody2D = obj.get_node("RigidBody2D")
	
	var x_dir = randf() / 2
	if spawn_pos.x > 0.0:
		x_dir *= -1
	x_dir += randf_range(-LAUNCH_FORCE_VARIANCE.x, LAUNCH_FORCE_VARIANCE.x)
	
	var y_dir = -1.0
	y_dir += randf_range(-LAUNCH_FORCE_VARIANCE.y, LAUNCH_FORCE_VARIANCE.y)
	
	var dir = Vector2(x_dir * laun_force.x * 30000,y_dir * laun_force.y * 30000)
	rb2d.apply_force(dir)
	rb2d.set_gravity_scale(grav_scale)
	rb2d.apply_torque(randf() * 150000)

func _on_spawn_timer_timeout():
	spawn_object()
