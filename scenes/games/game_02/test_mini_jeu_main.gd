extends Node2D

var enemi_speed = 7
var timer = 10

onready var enemi = preload("res://scenes/games/game_02/test_mini_jeu_enemi.tscn")
var dir = ["left","right"]
var player_dir = 1
var sensi = global.accelero_sensi
var win = false

func _process(delta):
	var angle_max = 6
	var rotation_to_player = clamp(Input.get_accelerometer().normalized().x*lerp(40,100,sensi),-angle_max,angle_max)
	$player/rot.rotation_degrees = rotation_to_player

func _ready():
	$player/rot/Sprite/Area2D.connect("area_entered",self,"player_col")
	randomize()
	$space_ship/Tween.interpolate_property($space_ship/Sprite,"position",$space_ship/Sprite.position,$space_ship/win_pos.position,timer+4,Tween.TRANS_EXPO,Tween.EASE_IN)
	$space_ship/Tween.interpolate_property($space_ship/Sprite,"scale",Vector2(0,0),Vector2(0.4,0.4),timer+4,Tween.TRANS_EXPO,Tween.EASE_IN)
	$space_ship/Tween.start()
	$Timer.start(timer)
	$spawn.start(rand_range(1.5,2.5))
	_on_spawn_timeout()

func player_col(area):
	if area.is_in_group("enemi") && !win:
		dead()

func _on_spawn_timeout():
	var enemi_inst = enemi.instance()
	enemi_inst.scale = Vector2(0,0)
	$enemi.add_child(enemi_inst)
	enemi_inst.get_node("AnimationPlayer").play("idle",-1,rand_range(0.5,1.5))
	enemi_inst.position = Vector2(rand_range($enemi_pos/spawn/left.position.x,$enemi_pos/spawn/right.position.x),50)
	enemi_inst.get_node("Node2D/position").interpolate_property(enemi_inst,"position",enemi_inst.position,Vector2(enemi_inst.position.x,$enemi_pos/pos_y_enemi.position.y),enemi_speed,Tween.TRANS_LINEAR,Tween.EASE_IN)
	enemi_inst.get_node("Node2D/position").interpolate_property(enemi_inst,"scale",Vector2(0,0),Vector2(10,10),enemi_speed,Tween.TRANS_LINEAR,Tween.EASE_IN)
	enemi_inst.get_node("Node2D/position").start()

func dead():
	$lose_audio.play()
	$player/AnimationPlayer.play("dead")
	$ui/AnimationPlayer.play("dead")
	$space_ship/Tween.stop_all()
	$space_ship/AnimationPlayer.stop(true)

func _on_Timer_timeout():
	$spawn.stop()

func change_scene():
	global.win_a_game()

func _on_Tween_tween_completed(object, key):
	win = true
	$space_ship/win.play("win")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "dead":
		global.lose_a_game()
