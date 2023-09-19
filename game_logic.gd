extends Node

var BASE_EXP_FOR_LVL_UP = 20
var LEVEL_CAP = 10
var SCORE_PER_HIT = 100
var MAX_HEALTH = 20.0
var MAX_STREAK = 30

var score = 0
var level = 1
var exp = 0.0
var exp_for_lvl_up = 20
var health = 20.0
var dead = false
var streak = 0

func game_start():
	level = 1
	score = 0
	exp = 0.0
	exp_for_lvl_up = BASE_EXP_FOR_LVL_UP
	health = MAX_HEALTH
	dead = false
	streak = 0
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
	add_exp(1.0)
	
	var streak_multiplier = 1 + (min(streak, MAX_STREAK) / 10)
	streak += 1
	
	if exp >= exp_for_lvl_up:
		level_up()
	
	add_score(roundi((SCORE_PER_HIT * get_game_speed() * streak_multiplier) / 10) * 10)

func add_score(amount):
	score += amount
	get_node("/root/Game/GameUI/Score").on_score_change()

func add_exp(amount):
	exp += amount
	exp = max(exp, 0.0)
	get_node("/root/Game/GameUI/EXPBar").value = (exp / float(exp_for_lvl_up)) * 100

func on_miss():
	streak = 0
	add_exp(-0.25)

func level_up():
	if level >= LEVEL_CAP:
		return
	
	level += 1
	update_game_speed()
	
	exp_for_lvl_up = BASE_EXP_FOR_LVL_UP * get_game_speed()
	
	add_exp(-1000.0)

func level_down():
	if level <= 1:
		return
	
	level -= 1
	update_game_speed()

func update_game_speed():
	get_node("/root/Game/GameUI/EXPBar/Level").on_level_change()
	get_node("/root/Game/ObjectSpawner/SpawnTimer").set_wait_time(1 / get_game_speed())

func get_game_speed():
	return 1.0 + (float(level) - 1) / 10.0
