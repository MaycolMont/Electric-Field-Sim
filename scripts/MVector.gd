extends RayCast2D
class_name MVector

@export var _line2d : Line2D

var _components : Vector2
var _magnitude : float

static var length : float
static var max_value : float
static var min_value : float

func _process(delta):
	if get_collider():
		hide()
	else:
		show()

func set_components(components : Vector2) -> void:
	_components = components.normalized() * length
	_magnitude = components.length()
	var tip_position = Vector2(_components.x, -_components.y)
	_line2d.points[1] = tip_position
	target_position = tip_position
	
	var sprite_tip = $TipSprite2D
	sprite_tip.position = tip_position
	sprite_tip.rotation = position.angle_to(tip_position)

func set_color() -> void:
	_line2d.default_color = magnitude_to_color(_magnitude)

static func set_range(magnitude: float) -> void:
	var max = max_value
	var min = min_value
	if not (max and min):
		max_value = magnitude
		min_value = magnitude
	else:
		if magnitude > max:
			max_value = magnitude
		elif magnitude < min:
			min_value = magnitude

func get_angle():
	return position.angle_to(target_position)

func update() -> void:
	pass

func magnitude_to_color(magnitude: float) -> Color:
	var difference = max_value - min_value
	
# Asegúrate de que la magnitud no se salga de los límites
	var clamped_mag = clamp(magnitude, 0, difference)

# Mapea la magnitud a un valor entre 0 y 1
	var normalized_value = (clamped_mag) / (difference)

# El color será un gradiente de rojo (magnitud baja) a verde (magnitud alta)
	return Color(1.0 - normalized_value, normalized_value, 0.0)
