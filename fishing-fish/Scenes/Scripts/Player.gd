extends CharacterBody3D

var motorRotation:float = 0.0

var power:float = 0.0
var input:Vector2 = Vector2()

const MAXSpeed = 25.0
const MAXFishingPower = 15.0

# State Machine for Boater
var state = 0

enum States {
	Boating, # 0
	Fishing, # 1
	Catching, # 2
	Struggling # 3
}

# Base stats should be put down.

# Nodes
@onready var boat:Node3D = $Boat
@onready var boatMotor:MeshInstance3D = $Boat/Motor
@onready var Camera:Camera3D = $Boat/TestPlayer/Camera3D

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")
	
	
	
	if state == States.Boating:
		power -= input.y * 0.005
		power = clamp(power,0.0,1.0)
		motorRotation += input.x * 0.5
		motorRotation = clamp(motorRotation,-35,35)
	
	boat.rotation_degrees.z = -power * 3
	boatMotor.rotation_degrees.y = motorRotation
	
	rotation_degrees.y -= motorRotation * (power * 0.05)
	velocity.x = (MAXSpeed * -power) * sin(rotation.y)
	velocity.z = (MAXSpeed * -power) * cos(rotation.y)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not state == States.Struggling:
		Camera.rotation_degrees.y -= event.relative.x
		Camera.rotation_degrees.x -= event.relative.y
		Camera.rotation_degrees.x = clamp(Camera.rotation_degrees.x,-90,90)

func throwLine():
