extends MeshInstance3D


const PLANET_SCENE = preload("res://src/07_08_09_solar_system/planet_3d.tscn")

var a: float = 0
var r: float = 1
var d: float = 1
var orbit_speed: float = 1
var orbit_axis: Vector3 = Vector3(0, 1, 0)
var v: Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
    a += delta * orbit_speed
    rotation_degrees += Vector3(0, delta * 10, 0)
    if v:
        position = v.rotated(orbit_axis, a)


func setup(radius: float, vector: Vector3, angle: float, speed: float) -> void:
    r = radius
    v = vector / r
    a = angle
    orbit_speed = speed
    orbit_axis = v.cross(Vector3(1, 0, 1)).normalized()
    scale = Vector3(r, r, r) / get_parent().scale


func spawn_moons(n: int, level: int) -> void:
    for i in range(n):
        var moon = PLANET_SCENE.instantiate()
        var vector = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
        vector *= randf_range(1.6, 3.8) / (1.2*level)
        add_child(moon)
        moon.setup(r / (1.2*level), vector, randf() * TAU, (randi_range(0, 2) - 0.5) * 2 * (randf() * 0.3 + 0.7))
        if level < 2:
            moon.spawn_moons(n, level + 1)
