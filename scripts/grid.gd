extends Control

@export var square_size: int = 15
var screen_size : Vector2

var grid_color: Color = Color(1.0, 1.0, 1.0, 1.0)
var _highlight_color: Color = Color(0.3, 0.6, 1.0, 1.0)

var vertical_lines : Array[float] = []
var horizontal_lines : Array[float] = []
var _vertical_nodes : Array[Line2D] = []
var _horizontal_nodes : Array[Line2D] = []

#region private
func _ready() -> void:
	screen_size = get_viewport_rect().size
	_draw_lines()

func _process(delta: float) -> void:
	_update_highlight_lines()
	
## Return the line's idx
func _get_focus_idx() -> Vector2:
	var mouse = get_global_mouse_position()

	var v_size = _vertical_nodes.size()
	var h_size = _horizontal_nodes.size()
	var v_idx = -1 if v_size == 0 else int(clamp(round(mouse.x / square_size), 0, v_size - 1))
	var h_idx = -1 if h_size == 0 else int(clamp(round(mouse.y / square_size), 0, h_size - 1))
	return Vector2(v_idx, h_idx)

func _update_highlight_lines() -> void:
	var focus_idx : Vector2 = _get_focus_idx()
	for i in _vertical_nodes.size():
		_vertical_nodes[i].default_color = _highlight_color if i == focus_idx.x else grid_color
	for i in _horizontal_nodes.size():
		_horizontal_nodes[i].default_color = _highlight_color if i == focus_idx.y else grid_color

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

	for x in range(0, width + 1, square_size):
		vertical_lines.append(x)
		_vertical_nodes.append(_draw_line(Vector2(x, 0),
				Vector2(x, height)))

	for y in range(0, height + 1, square_size):
		horizontal_lines.append(y)
		_horizontal_nodes.append(_draw_line(Vector2(0, y),
				Vector2(width, y)))

#endregion

#region public

func get_focus_point() -> Vector2:
	var focus_idx : Vector2 = _get_focus_idx()
	return Vector2(focus_idx.x, focus_idx.y)
	
#endregion
