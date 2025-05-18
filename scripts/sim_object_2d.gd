extends CharacterBody2D
class_name SimObject2D

var current_state = state.MOVE
enum state {MOVE, FIXED}

func _ready():
	input_pickable = true
	input_event.connect(_on_input_event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if current_state == state.MOVE:
		var target_position = get_global_mouse_position() - position
		var collision = move_and_collide(target_position)
		if not collision:
			position = get_global_mouse_position()

func _sim_motion():
	pass

func _block() -> void:
	pass
	
func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ok"):
		current_state = state.MOVE if current_state == state.FIXED else state.FIXED
	elif event.is_action_pressed("cancel"):
		queue_free()
