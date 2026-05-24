extends Control

var min_square_size: int = 15
var max_square_size: int = 40
var square_size: int = 20
var scale_factor: float = 1.0
var grid_color: Color = Color(1.0, 1.0, 1.0, 1.0)
var screen_size : Vector2
var vertical_lines : Array[int] = []
var horizontal_lines : Array[int] = []
var _vertical_nodes : Array[Line2D] = []
var _horizontal_nodes : Array[Line2D] = []
var _highlight_color: Color = Color(0.3, 0.6, 1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	_draw_lines()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	_highlight_nearest(vertical_lines, _vertical_nodes, mouse.x, true)
	_highlight_nearest(horizontal_lines, _horizontal_nodes, mouse.y, false)


func _highlight_nearest(positions: Array[int], nodes: Array[Line2D], mouse_coord: float, is_vertical: bool) -> void:
	var nearest_idx = -1
	var nearest_dist = INF
	for i in positions.size():
		var dist = abs(positions[i] - mouse_coord)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_idx = i

	for i in nodes.size():
		if i == nearest_idx:
			nodes[i].default_color = _highlight_color
		else:
			nodes[i].default_color = grid_color

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom in"):
		_zoom_in()
	if event.is_action_pressed("zoom out"):
		_zoom_out()

func _draw_line(start: Vector2, end: Vector2) -> Line2D:
	var line = Line2D.new()
	line.width = 1.0
	line.default_color = grid_color
	line.add_point(start)
	line.add_point(end)
	add_child(line)
	return line

func _draw_lines() -> void:
	var width = screen_size.x
	var height = screen_size.y

	# Draw vertical lines
	for x in range(0, width/square_size):
		var x_position : int = x * square_size
		vertical_lines.append(x_position)
		_vertical_nodes.append(_draw_line(Vector2(x_position, 0),
				Vector2(x_position, height)))

	# Draw horizontal lines
	for y in range(0, height/square_size):
		var y_position : int = y * square_size
		horizontal_lines.append(y_position)
		_horizontal_nodes.append(_draw_line(Vector2(0, y_position),
				Vector2(width, y_position)))

func _zoom_in() -> void:
	print_debug("Square size: ", square_size)
	square_size += scale_factor
	if square_size > max_square_size:
		square_size = min_square_size
	
func _zoom_out() -> void:
	pass
