extends SimObject2D
class_name Particle

var _charge : float
var _mass : float = 2
var _field : Vector2
var A : float = _charge / _mass

func _physics_process(delta):
	velocity += A * _field * delta

func set_charge(charge: float) -> void:
	var sprite2d : Sprite2D = $Sprite2D
	_charge = charge
	if charge > 0:
		sprite2d.texture = load("res://assets/proton.png")

func get_charge() -> float:
	return _charge


func _on_visible_on_screen_notifier_2d_screen_exited():
	pass # Replace with function body.
