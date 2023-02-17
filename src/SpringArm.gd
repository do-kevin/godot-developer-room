extends Spatial

export var mouse_sensitivity := 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true) # allow camera to move independently from the character
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.x = rotation_degrees.x - (event.relative.y * mouse_sensitivity)
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0) # prevent camera from rolling over; tweak pitch
		
		rotation_degrees.y = rotation_degrees.y - (event.relative.x * mouse_sensitivity)
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0) # prevents rotation from accumulating
