extends Node2D

@export var _grid_size : float = 100
@export var particle_scene : PackedScene
@export var m_vector_scene : PackedScene

var _particles : Array[Node]
var _vectors : Array[MVector]
var _electric_constant : int = 9 * 10**3
var screen_size : Vector2

func _process(delta):
	for particle in _particles:
		if particle.current_state == SimObject2D.state.MOVE:
			_update_field()

func _get_grid() -> Vector2:
	screen_size = get_viewport_rect().size
	var rows : int = ceil(screen_size.y / _grid_size)
	var colums : int = ceil(screen_size.x / _grid_size)
	return Vector2(rows, colums)

func _add_vectors() -> void:
	var grid : Vector2 = _get_grid()
	MVector.length = _grid_size * 0.8
	
	for row in range(grid.x):
		for col in range(grid.y):
			var x : float = (col * _grid_size)
			var y : float = (row * _grid_size)
			_create_vector(Vector2(x, y))

	for vector in _vectors:
		vector.set_color()

func _create_vector(vector_position: Vector2) -> void:
	var electric_field_vector = _get_electric_field_vector(vector_position)
	var electric_field_magnitude = electric_field_vector.length()
	var vector : MVector = m_vector_scene.instantiate()

	vector.set_components(electric_field_vector)
	vector.position = vector_position
	MVector.set_range(electric_field_magnitude)

	_vectors.append(vector)
	add_child(vector)

func _get_electric_field_vector(vector_position: Vector2) -> Vector2:
	var electric_field_vector : Vector2 = Vector2.ZERO
	for particle in _particles:
		var dx = vector_position.x - particle.position.x
		var dy = -(vector_position.y - particle.position.y)
		var r = sqrt(dx**2 + dy**2)
		if r > _grid_size/3:
			var q = particle.get_charge()
			var common_factor = _electric_constant * (q / (r**3))
			electric_field_vector += common_factor * Vector2(dx, dy)

	return electric_field_vector

func _update_field() -> void:
	for vector in _vectors:
		var updated_vector = _get_electric_field_vector(vector.position)
		vector.set_components(updated_vector)
		vector.set_color()

func add_particle(charge: float) -> void:
	var particle : Particle = particle_scene.instantiate()
	particle.set_charge(charge)
	_particles.append(particle)
	particle.tree_exited.connect(_on_particle_remove.bind(particle))
	add_child(particle)
	print(particle.state)
	if len(_particles) == 1:
		if _vectors:
			for vector in _vectors:
				vector.show()
		else:
			_add_vectors()

func _on_particle_remove(particle):
	if len(_particles) == 1:
		for vector in _vectors:
			vector.hide()
	_particles.erase(particle)
	_update_field()
