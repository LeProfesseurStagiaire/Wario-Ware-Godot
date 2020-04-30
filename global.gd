extends Node

var games_path = ["res://scenes/games/game_01/main.tscn",
"res://scenes/games/game_02_02/main.tscn",
"res://scenes/games/game_03/main.tscn"
]
var games_ended = []

var life = 3
var time_accel = 1

var score = 0
var best_score = 0

var accelero_sensi = 0
var last_game_win = null

func win_a_game():
	last_game_win = true
	score += 1
	if score > best_score:
		best_score = score
	back_to_menu()

func lose_a_game():
	last_game_win = false
	global.life -= 1
	back_to_menu()

func back_to_menu():
	global.time_accel += 0.15
	Engine.time_scale = 1
	get_tree().change_scene("res://scenes/transition_menu/transition_menu.tscn")
