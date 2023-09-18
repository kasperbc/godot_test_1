extends Node

var HITS_FOR_LVL_UP = 20
var LEVEL_CAP = 10
var SCORE_PER_HIT = 10
var MAX_HEALTH = 20.0

var level = 1
var score = 0
var objects_hit = 0
var health = 20.0
var dead = false

func game_start():
	level = 1
	score = 0
	objects_hit = 0
	health = MAX_HEALTH
	dead = false
	get_tree().change_scene_to_file("res://game.tscn")

func _process(delta):
	regen_health(delta / 1.5)

# PLAYER HEALTH
	
func regen_health(amount):
	if dead:
		return
	
	health += amount
	
	get_node("/root/Game/GameUI/HealthBar").value = int((health / MAX_HEALTH) * 100)
	
	health = min(health, MAX_HEALTH)
	
func damage_health(amount):
	health -= amount
	
	health = max(health, 0.0)
	
	get_node("/root/Game/Camera").screen_shake(1,1)
	
	if health <= 0.0 and not dead:
		get_node("/root/Game/GameOverUI").visible = true
		get_node("/root/Game/GameOverUI/ScoreText").text = "Game Over\n\nScore: %s" % score
		get_node("/root/Game/GameUI").visible = false
		dead = true

# SCORE/LEVELS

func on_shootable_obj_hit():
	objects_hit += 1
	
	if objects_hit >= (HITS_FOR_LVL_UP * level) + ((HITS_FOR_LVL_UP * float(1 + level / 10)) - HITS_FOR_LVL_UP):
		level_up()
	
	score += roundi((SCORE_PER_HIT * get_game_speed()) / 10) * 10
	get_node("/root/Game/GameUI/Score").on_score_change()

func level_up():
	if level >= LEVEL_CAP:
		return
	
	level += 1
	update_game_speed()
	
func level_down():
	if level <= 1:
		return
	
	level -= 1
	update_game_speed()

func update_game_speed():
	get_node("/root/Game/GameUI/Level").on_level_change()
	get_node("/root/Game/ObjectSpawner/SpawnTimer").set_wait_time(1 / get_game_speed())

func get_game_speed():
	return 1.0 + float(level) / 10.0
