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

	
func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right2')
	var left = Input.is_action_pressed('ui_left2')
	var jump = Input.is_action_just_pressed('ui_up2')
	var qAttack = Input.is_action_just_pressed("qAttack2")
	var pAttack = Input.is_action_just_pressed("pAttack2")

	if right:
		velocity.x += run_speed
		if not attacking or not plyr_flip:
			player_sprite.flip_h = false
	elif left:
		velocity.x -= run_speed
		if not attacking or plyr_flip:
			player_sprite.flip_h = true
			
	if jump and is_on_floor():
		if not attacking:
			#Jump
			pass
		jumping = true
		velocity.y = jump_speed
		
	if qAttack:
		plyr_flip = player_sprite.flip_h
		attacking = true
		#attack
		$qAttack/qAttack.disabled = false
		
	if pAttack and is_on_floor():
		attacking = true
		#attack
		run_speed = 200
		
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	if velocity.x != 0 and is_on_floor() and not attacking:
		pass
		#Run
	if jumping and is_on_floor():
		jumping = false
	

func _on_Area2D_area_entered(area):
	if area.is_in_group("1dmg") or area.is_in_group("5dmg"):
		if area.is_in_group("1dmg"):
			hp -= 1
		elif area.is_in_group("5dmg"):
			hp -= 5	
		print ("current hp: " + str(hp))
		if hp <= 0:
			#death
			queue_free()
