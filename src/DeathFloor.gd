extends RigidBody

func _ready():
	connect("body_entered",self,"_on_body_entered")

func _on_body_entered(body):
	print("[DeathFloor] Player is out of bounds.")
	get_tree().reload_current_scene()
