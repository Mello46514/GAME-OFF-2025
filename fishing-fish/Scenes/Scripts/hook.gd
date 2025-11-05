extends CharacterBody3D

signal gotcha

const gravity = 1

var stuck = false

@onready var line := $Line

func _physics_process(_delta):
	
	if not stuck:
		velocity.y -= gravity
	else:
		velocity = Vector3.ZERO
	
	line.points[0] = global_position
	line.points[1] = Global.PlayerFishingLinePos
	
	
	if not is_on_floor() or is_on_wall():
		move_and_slide() # Assuming your character moves here
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider() is AnimatableBody3D: # or RigidBody2D
				var Enemy = collision.get_collider()
				if Enemy.get_parent() != null:
					if Enemy.get_parent().is_in_group("Enemy"):
						stuck = true
						gotcha.connect(Enemy.get_parent()._help)
						gotcha.emit()
