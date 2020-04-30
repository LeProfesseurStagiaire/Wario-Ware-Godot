extends Control

func _ready():
	if global.life > 0 :
		$PopupMenu/HSlider.value = global.accelero_sensi
		_on_HSlider_value_changed($PopupMenu/HSlider.value)
		randomize()
		if global.last_game_win :
			$result.text = "you win !" 
			$TextureRect.modulate = Color(0.501961, 0.858824, 1)
		elif global.last_game_win == false:
			$result.text = "you lose..."
			$TextureRect.modulate = Color(1, 0.54902, 0.54902)
		else:
			$result.text = ""
			$TextureRect.modulate = Color(1, 1, 1)
	else:
		global_sound.get_node("AudioStreamPlayer").stop()
		$result.text = "the game is over !"
		$Timer.stop()
		$Timer.start(5)
		$TextureRect.modulate = Color(1, 0, 0)
		$end.play()
		$pause.disabled = true
		var save_game = File.new()
		save_game.open("user://savegame.save", File.WRITE)
		save_game.store_line(to_json(global.best_score))
		save_game.close()
	$score.bbcode_text = "[center][wave amp=30 freq=20] score : "+str(global.score)
	$best_score.text = "Best : " +str(global.best_score)
	for x in $hearts2.get_children():
		if x.get_name().to_float() <= global.life:
			x.modulate = Color(1,1,1)
		else:
			x.modulate = Color(0.360784, 0.360784, 0.360784, 0.315686)

func _on_Timer_timeout():
	Engine.time_scale = global.time_accel
	get_tree().change_scene(get_path())

func get_path():
	if global.life <= 0:
		return "res://scenes/start_menu/start_menu.tscn"
	else:
		var scenes = global.games_path
		scenes.shuffle()
		for x in scenes:
			if ! global.games_ended.has(x):
				global.games_ended.append(x)
				return x
		global.games_ended.clear()
		global.games_ended.append(scenes[0])
		return scenes[0]

func _on_pause_pressed():
	$PopupMenu.popup()
	$PopupMenu/pause.play()
	get_tree().paused = true
	$Timer.stop()
	AudioServer.set_bus_effect_enabled(0,0,true)

func _on_PopupMenu_popup_hide():
	get_tree().paused = false
	$Timer.start(2)
	AudioServer.set_bus_effect_enabled(0,0,false)

func _on_HSlider_value_changed(value):
	$PopupMenu/info2.text = str($PopupMenu/HSlider.value)
	global.accelero_sensi = $PopupMenu/HSlider.value

func _on_quit_pressed():
	global.life = 0
	global.lose_a_game()
