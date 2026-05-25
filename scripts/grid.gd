extends Control

var min_square_size: int = 15
var max_square_size: int = 30
var square_size: int = 15
var scale_factor: float = 1.0
var grid_color: Color = Color(1.0, 1.0, 1.0, 1.0)
var screen_size : Vector2
var vertical_lines : Array[float] = []
var horizontal_lines : Array[float] = []
var _vertical_nodes : Array[Line2D] = []
var _horizontal_nodes : Array[Line2D] = []
var _highlight_color: Color = Color(0.3, 0.6, 1.0, 1.0)
var _offset: Vector2

func hide_grid()-> void:
	for node in _vertical_nodes:
		node.hide()
	
	for node in _vertical_nodes:
		node.hide()
		
func _ready() -> void:
	screen_size = get_viewport_rect().size
	_draw_lines()

func _process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	var start_x = fmod(_offset.x, square_size)
	if start_x < 0:
		start_x += square_size
	var start_y = fmod(_offset.y, square_size)
	if start_y < 0:
		start_y += square_size

	var v_size = _vertical_nodes.size()
	var h_size = _horizontal_nodes.size()
	var v_idx = -1 if v_size == 0 else int(clamp(round((mouse.x - start_x) / square_size), 0, v_size - 1))
	var h_idx = -1 if h_size == 0 else int(clamp(round((mouse.y - start_y) / square_size), 0, h_size - 1))

	for i in _vertical_nodes.size():
		_vertical_nodes[i].default_color = _highlight_color if i == v_idx else grid_color
	for i in _horizontal_nodes.size():
		_horizontal_nodes[i].default_color = _highlight_color if i == h_idx else grid_color

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom in"):
		_zoom_in()
	if event.is_action_pressed("zoom out"):
		_zoom_out()

func _clear_lines() -> void:
	for node in _vertical_nodes + _horizontal_nodes:
		node.queue_free()
	vertical_lines.clear()
	horizontal_lines.clear()
	_vertical_nodes.clear()
	_horizontal_nodes.clear()

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

	var start_x = fmod(_offset.x, square_size)
	if start_x < 0:
		start_x += square_size
	var start_y = fmod(_offset.y, square_size)
	if start_y < 0:
		start_y += square_size

	for x in range(start_x, width + 1, square_size):
		vertical_lines.append(x)
		_vertical_nodes.append(_draw_line(Vector2(x, 0),
				Vector2(x, height)))

	for y in range(start_y, height + 1, square_size):
		horizontal_lines.append(y)
		_horizontal_nodes.append(_draw_line(Vector2(0, y),
				Vector2(width, y)))

func _zoom_in() -> void:
	var mouse = get_global_mouse_position()
	var grid_x = (mouse.x - _offset.x) / square_size
	var grid_y = (mouse.y - _offset.y) / square_size

	square_size += scale_factor
	if square_size > max_square_size:
		square_size = min_square_size

	_offset.x = mouse.x - grid_x * square_size
	_offset.y = mouse.y - grid_y * square_size

	_clear_lines()
	_draw_lines()

func _zoom_out() -> void:
	var mouse = get_global_mouse_position()
	var grid_x = (mouse.x - _offset.x) / square_size
	var grid_y = (mouse.y - _offset.y) / square_size

	square_size -= scale_factor
	if square_size < min_square_size:
		square_size = max_square_size

	_offset.x = mouse.x - grid_x * square_size
	_offset.y = mouse.y - grid_y * square_size

	_clear_lines()
	_draw_lines()
