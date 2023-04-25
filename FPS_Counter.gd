extends Control
onready var counter = get_node("Counter_Container/Counter")

func _process(delta):
	counter.text = str(Engine.get_frames_per_second())
