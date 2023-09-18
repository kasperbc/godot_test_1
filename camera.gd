extends Camera2D

@export var UI_INTENSITY = 10.0

var camera_intensity = 0.0
var intensity_falloff = 0.0

func _process(delta):
	camera_intensity -= delta / intensity_falloff
	
	camera_intensity = max(camera_intensity, 0)
	
	var random_pos = get_random_shake_pos()
	position = random_pos
	
	var ui_pos = get_random_shake_pos() * UI_INTENSITY
	get_parent().get_node("GameUI").offset = ui_pos

func get_random_shake_pos():
	return Vector2(randf_range(-camera_intensity, camera_intensity), randf_range(-camera_intensity, camera_intensity))

func screen_shake(intensity, duration):
	if camera_intensity > intensity:
		return
	
	camera_intensity = intensity
	intensity_falloff = duration
