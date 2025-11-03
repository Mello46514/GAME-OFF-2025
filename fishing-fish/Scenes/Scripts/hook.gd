extends CharacterBody3D

signal gotcha

const gravity = 1

func _physics_process(_delta):
	
	velocity.y += gravity
	
	
	
	move_and_slide() # Assuming your character moves here
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is Area3D: # or RigidBody2D
			var Enemy = collision.get_collider()
			if Enemy.get_parent() != null:
				if Enemy.get_parent().is_in_group("Enemy"):
					Enemy.get_parent().link(gotcha, "_help()")
					gotcha.emit()
