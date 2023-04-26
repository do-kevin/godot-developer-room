extends KinematicBody

var timer = null

var hurt_bad := false
var hurt_badly := false

# stats
var health := 100
var max_health := 100

# animation
var is_dead := false


export var speed := 7.0 # movement speed
export var jump_strength := 20.0
export var gravity := 50.0


var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN # ground our character

onready var _spring_arm: SpringArm = $SpringArm
onready var _model: Spatial = $FemaleCyborg
onready var animation: AnimationPlayer = $FemaleCyborg/AnimationPlayer
onready var animation_tree: AnimationTree = $FemaleCyborg/AnimationTree

var state_machine = null

func beat_heart() -> void:
	print("START")
	Input.start_joy_vibration(0, 0.0, 0.05, 0.0)
	
func beat_heart_2() -> void:
	Input.start_joy_vibration(0, 0.0, 0.10, 0.0)

func _ready():
	animation_tree.active = true
	state_machine = $FemaleCyborg/AnimationTree.get("parameters/playback")
	if hurt_bad:
		timer = Timer.new()
		timer.connect("timeout", self, "beat_heart")
		add_child(timer)
		timer.start()
	if hurt_badly:
		timer.stop()
		remove_child(timer)
		timer = Timer.new()
		timer.connect("timeout", self, "beat_heart_2")
		add_child(timer)
		timer.start()
		

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
	
	
var death_roll = RandomNumberGenerator.new();
	
func _process(_delta: float) -> void:
	_spring_arm.translation = translation
	if health <= max_health * 0.75:
		state_machine.travel("damaged_nod")
		hurt_bad = true
	if health <= max_health * 0.5:
		state_machine.travel("damaged_nod_hard")
		hurt_bad = false
		hurt_badly = true
	if health <= 0 and !is_dead:
		death_roll.randomize()
		animation_tree.active = false
		var dice_value = death_roll.randi_range(1, 2)

		if dice_value % 2 == 0:
			animation.play("death_1")
		else:
			animation.play("death_2")

		is_dead = true

		yield(get_tree().create_timer(3), "timeout") # delay code execution by 3 seconds

		get_tree().reload_current_scene() # restart game



func take_damage(amount: int) -> int:
	health -= amount
	print("[took damage]: ", health)
	if health <= 0:
		health = 0
		
	if (health < 0):
		Input.stop_joy_vibration(0)
	else:
		Input.start_joy_vibration(0, 0.17, 0.0, 0.15)

	return health

func _input(event):
	if event.is_action_pressed("hurt"):
		var new_health = take_damage(10)
		print("[Player] - new hp after damage: ", new_health)
		
	
