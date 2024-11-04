extends Control

const PLANET_SCENE = preload("res://src/07_08_09_solar_system/planet.tscn")

var center: Vector2
var a: float = 0
var r: float = 30
var d: float = 0
var orbit_speed: float = 1
var color: Color = Color.WHITE


func _ready() -> void:
    center = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)


func _physics_process(delta: float) -> void:
    a += delta * orbit_speed
    position = Vector2(d * cos(a), d * sin(a))


func _draw() -> void:
    draw_circle(Vector2.ZERO, r, color, true, -1, true)


func setup(radius: float, distance: float, angle: float, speed: float) -> void:
    r = radius
    d = distance
    a = angle
    orbit_speed = speed


func spawn_moons(n: int, level: int) -> void:
    print("Level: %d" % level)
    for i in range(n):
        var moon = PLANET_SCENE.instantiate()
        moon.setup(r / (1.4*level), randf_range(150, 350) / (1.2*level), randf() * TAU, (randi_range(0, 2) - 0.5) * 2 * (randf() * 0.3 + 0.7))
        add_child(moon)
        moon.queue_redraw()
        if level < 2:
            moon.spawn_moons(n, level + 1)