extends Node2D
@onready var vector : MVector = $MVector

# Called when the node enters the scene tree for the first time.
func _ready():
	vector.length = 40
	vector.position = Vector2.ONE * 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cal_dir()
	
func _input(event):
	if event.is_action_pressed("cancel"):
		print(vector.get_angle())

func cal_dir():
	var dir = $Particle.global_position - vector.global_position
	vector.set_components(Vector2(dir.x, -dir.y))
