extends Node2D

var nb_taupe = 5
var timer = 10

var node_to_click = []
var node_existing = []

var can_click = true
var win 

func _ready():
	$asteroid/Tween.interpolate_property($asteroid/Sprite,"scale",Vector2(0.03,0.03),Vector2(5,5),timer,Tween.TRANS_EXPO,Tween.EASE_IN)
	$asteroid/Tween.start()
	$Timer.start(rand_range(0.1,0.3))
	randomize()
	while $taupes.get_child_count() < nb_taupe +1:
		var taupe = $taupes/taupe.duplicate()
		$taupes.add_child(taupe)
		taupe.get_node("Area2D").connect("input_event",self,"area_click",[taupe])
		taupe.get_node("AnimationPlayer").connect("animation_finished",self,"anim_end",[taupe])
		taupe.rotation_degrees = rand_range(0,360)
		node_existing.append(taupe)
	$taupes/taupe.queue_free()

func area_click(viewport, event, shape_idx, taupe):
	if event.is_pressed() && node_to_click.has(taupe) && can_click:
		taupe.get_node("AnimationPlayer").queue_free()
		taupe.get_node("taupe").queue_free()
		taupe.get_node("trou").show()
		node_to_click.erase(taupe)
		$tap_audio.play()
		if node_to_click.size() <= 0 && node_existing.size() <= 0:
			$Timer.stop()
#			$asteroid/Sprite/Sprite2.hide()
			$asteroid/Tween.stop_all()
			$asteroid/Tween.interpolate_property($asteroid/Sprite/Sprite2,"scale",$asteroid/Sprite/Sprite2.scale,Vector2(0,0),0.2,Tween.TRANS_EXPO,Tween.EASE_OUT)
			$asteroid/Tween.start()
			$asteroid/Tween.interpolate_property($asteroid/Sprite,"scale",$asteroid/Sprite.scale,Vector2(5,5),1,Tween.TRANS_EXPO,Tween.EASE_IN)
			$asteroid/Tween.start()
			$win_audio.play()
			win = true

func anim_end(anim_name, taupe):
	node_to_click.erase(taupe)
	node_existing.append(taupe)

func _on_Timer_timeout():
	if node_existing:
		var taupe = node_existing[rand_range(0,node_existing.size())]
		node_to_click.append(taupe)
		node_existing.erase(taupe)
		taupe.get_node("AnimationPlayer").play("taupe_sort",-1,rand_range(0.3,0.7))
		var s = $asteroid/spawn_shape
		taupe.position = Vector2(rand_range(s.rect_position.x,s.rect_size.x),rand_range(s.rect_position.y,s.rect_size.y))
	$Timer.start(rand_range(0.1,0.3))

func _process(delta):
	$asteroid/Sprite.rotation_degrees += 0.2

func _on_Tween_tween_step(object, key, elapsed, value):
	if elapsed == timer && !win :
		can_click = false
		$halo_death.show()
		$lose_audio.play()
		$asteroid/end_timer.start(1)
	if elapsed == 1 && win:
		global.win_a_game()

func _on_end_timer_timeout():
	global.lose_a_game()
