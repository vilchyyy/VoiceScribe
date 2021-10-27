extends KinematicBody2D

export (int) var run_speed = 500
export (int) var jump_speed = -1000
export (int) var gravity = 2500
onready var player_sprite = $Sprite

var velocity = Vector2()
var jumping = false
var attacking = false
var plyr_flip = false
var hp = 20

func play_anim(anim):
	player_sprite.stop()
	player_sprite.play(anim)

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_up')
	var qAttack = Input.is_action_just_pressed("qAttack")
	var pAttack = Input.is_action_just_pressed("pAttack")

	if right:
		velocity.x += run_speed
		if not attacking or not plyr_flip:
			player_sprite.flip_h = false
			$qAttack.set_scale(Vector2(1, 1))
			$pAttack.set_scale(Vector2(1, 1))
	elif left:
		velocity.x -= run_speed
		if not attacking or plyr_flip:
			player_sprite.flip_h = true
			$qAttack.set_scale(Vector2(-1, 1))
			$pAttack.set_scale(Vector2(-1, 1))
	elif is_on_floor() and not attacking and velocity.x == 0 and player_sprite.animation != "Take Hit":
		player_sprite.play("Idle")
	if jump and is_on_floor():
		if not attacking:
			play_anim("Jump")
		jumping = true
		velocity.y = jump_speed
		
	if qAttack:
		plyr_flip = player_sprite.flip_h
		attacking = true
		play_anim("Attack1")
		$qAttack/qAttack.disabled = false
		
	if pAttack and is_on_floor():
		attacking = true
		play_anim("Attack2")
		run_speed = 200
		
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	if velocity.x != 0 and is_on_floor() and not attacking:
		player_sprite.play("Run")
	if jumping and is_on_floor():
		jumping = false
	
func _on_Sprite_animation_finished():
	if player_sprite.animation == "Death":
		queue_free()
	if velocity.y <-20:
		play_anim("Jump")
	elif velocity.y > 0 :
		play_anim("Fall")
	if player_sprite.animation == "qAttack" or "pAttack":
		attacking = false
		$qAttack/qAttack.disabled = true
		$pAttack/pAttack.disabled = true
		run_speed = 500

func _on_Sprite_frame_changed():
	if player_sprite.animation == "Attack2":
		if player_sprite.frame == 4:
			$pAttack/pAttack.disabled = false


func _on_Area2D_area_entered(area):
	if area.is_in_group("1dmg2") or area.is_in_group("5dmg2"):
		if area.is_in_group("1dmg2"):
			hp -= 1
		elif area.is_in_group("5dmg2"):
			hp -= 5	
		print ("current hp: " + str(hp))
		if hp <= 0:
			player_sprite.play("Death")
			queue_free()
		



