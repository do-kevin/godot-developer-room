extends KinematicBody

export var speed := 7.0 # movement speed
export var jump_strength := 20.0
export var gravity := 50.0

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN # ground our character

onready var _spring_arm: SpringArm = $SpringArm
onready var _model: Spatial = $FemaleCyborg

func _physics_process(delta: float) -> void:
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	move_direction = move_direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized() # rotate input direction to match camera's look direction; makes move direction relative to the camera; normalize so going diagnol doesn't make us move faster
	_velocity.x = move_direction.x * speed # set the velocity variable on the ground
	_velocity.z = move_direction.z * speed
	_velocity.y = _velocity.y - (gravity * delta) # every frame, pull velocity down using gravity
	
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
	
	if is_jumping:
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO # turn off snapping
	elif just_landed:
		_snap_vector = Vector3.DOWN # snap character down to ground
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	if _velocity.length() > 0.02: # rotate character to match its movement
		var look_direction = Vector2(_velocity.z, _velocity.x)
		_model.rotation.y = look_direction.angle() # turns Vector2 into radians
	
	
func _process(_delta: float) -> void:
	_spring_arm.translation = translation
