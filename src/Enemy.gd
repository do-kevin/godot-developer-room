extends KinematicBody

onready var player: KinematicBody = get_node("/root/Main/Player")
onready var hitbox: Area = get_node("HitBox")

export var movement_speed := 3.0

var attack_distance := 1.5
var velocity := Vector3()
var seen_player := false

func _ready():
	pass
	

func attack():
	var players = hitbox.get_overlapping_bodies()
	
	for enemy in players:
		if enemy.has_method("take_damage"):
			enemy.take_damage(10)


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
		var player_direction := player.global_transform.origin
		player_direction.y = global_transform.origin.y
		self.look_at(player_direction, Vector3.UP)
		self.rotate_object_local(Vector3.UP, PI)
