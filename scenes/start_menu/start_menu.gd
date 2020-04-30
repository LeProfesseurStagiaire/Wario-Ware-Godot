extends Control

var game_info

func _ready():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.READ)
	var result := JSON.parse(save_game.get_as_text())
	if result.error:
		save_game.close()
	else :
		global.best_score = parse_json(save_game.get_line())
		save_game.close()
	
	Engine.time_scale = 1
	reset_game()
	$score.text = "Best score : " + str(global.best_score)

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/transition_menu/transition_menu.tscn")

func reset_game():
	global_sound.get_node("AudioStreamPlayer").play()
	global.life = 3
	global.time_accel = 1
	global.score = 0
	global.accelero_sensi = 0
	global.last_game_win = null
	global.games_ended = []
