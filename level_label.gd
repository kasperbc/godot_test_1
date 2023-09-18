extends Label

func on_level_change():
	var level = str(GameLogic.level)
	
	if GameLogic.level >= GameLogic.LEVEL_CAP:
		level = "MAX"
	
	text = "L%s" % level
