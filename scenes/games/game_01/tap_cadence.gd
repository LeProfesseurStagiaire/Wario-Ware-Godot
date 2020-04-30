extends Node2D

var click_to_win = 5
var time_left = 10

func _ready():
	$end/Tween.interpolate_property($end/Sprite,"scale",$end/Sprite.scale,Vector2(3.8,3.8),time_left,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$end/Tween.start()
	$player/AnimationPlayer.play("idle",-1,0.7)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_pressed() :
		if $player.scale.x > 1:
			$player/scale.interpolate_property($player,"scale",$player.scale,Vector2($player.scale.x - lerp(0,2,1.0/(click_to_win-1)), $player.scale.y - lerp(0,2,1.0/(click_to_win-1))),0.2,Tween.TRANS_QUINT,Tween.EASE_OUT)
		else:
			$player/AnimationPlayer.play("win")
			$player/scale.interpolate_property($player,"scale",$player.scale,Vector2(0,0),1,Tween.TRANS_EXPO,Tween.EASE_OUT)
		$player/scale.start()
		$walk_sound.play()

func end():
	$end/Tween.stop_all()
	$end/Tween.interpolate_property($end/Sprite,"scale",$end/Sprite.scale,Vector2(15,15),1,Tween.TRANS_EXPO,Tween.EASE_OUT)
	$end/Tween.start()

func win():
	global.win_a_game()

func _on_Tween_tween_step(object, key, elapsed, value):
	if time_left == elapsed:
		$end/ColorRect.show()
		$end/color.interpolate_property($end/ColorRect,"color",Color(1,0,0,0),Color(1,0,0,1),1,Tween.TRANS_EXPO,Tween.EASE_OUT)
		$end/color.start()
		$player/Sprite/Area2D/CollisionShape2D.disabled = true
		$end/end_timer.start(1)
		$lose_sound.play()

func _on_end_timer_timeout():
	global.lose_a_game()
