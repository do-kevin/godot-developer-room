extends KinematicBody

onready var player: KinematicBody = get_node("/root/Main/Player")

export var movement_speed := 1.0

var attack_distance := 1.5
var velocity := Vector3()
var seen_player := false

func _ready():
	pass


func _physics_process(_delta: float):
	for ray in $Pivot.get_children():	
		if ray is RayCast and ray.is_colliding() and ray.get_collider() is KinematicBody:
			seen_player = true
			ray.enabled = true
			var distance = translation.distance_to(player.translation)
			if distance > attack_distance:
				var direction = (player.translation - translation).normalized()

				velocity.x = direction.x * movement_speed
				velocity.y = 0
				velocity.z = direction.z * movement_speed

				velocity = move_and_slide(velocity, Vector3.UP)
			elif distance <= attack_distance:
				$AnimationPlayer.play("attack_1")
	
	if seen_player:
		$Pivot.look_at(player.global_transform.origin, Vector3.UP)
		$Zombie.look_at(Vector3(-player.global_transform.origin.x, -player.get_floor_angle(), -player.global_transform.origin.z), Vector3.UP)
