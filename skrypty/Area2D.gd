extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hp = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$icon.play("idle") 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_guwno_area_entered(area):
	if area.is_in_group("1dmg") or area.is_in_group("5dmg"):
		if area.is_in_group("1dmg"):
			hp -= 1
		elif area.is_in_group("5dmg"):
			hp -= 5	
		print ("current hp: " + str(hp))
		if hp <= 0:
			$icon.play("death")
		elif hp > 0:
			$icon.play("damaged")
		



func _on_icon_animation_finished():
	if $icon.animation == "death":
		queue_free()
	$icon.play("idle")
	
