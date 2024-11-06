extends Node3D

var x: float = 0.01
var y: float = 0.0
var z: float = 0.0

var sigma: float = 10.0
var rho: float = 28.0
var beta: float = 8.0 / 3.0

var points := []
var mesh = ImmediateMesh.new()

@onready var mesh_instance = $MeshInstance


func _physics_process(delta: float) -> void:
    var dx = sigma * (y - x) * delta * 0.4
    var dy = (x * (rho - z) - y) * delta * 0.4
    var dz = (x * y - beta * z) * delta * 0.4

    x += dx
    y += dy
    z += dz

    points.append(Vector3(x, y, z))

    if points.size() < 2:
        return

    create_mesh()


func create_mesh():
    mesh.clear_surfaces()
    mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
    for i in points.size():
        var c = Color.RED
        c.s = 1.0
        c.v = 1.0
        c.h = fmod(c.h + i * 0.001, 1.0)
        mesh.surface_set_color(c)
        mesh.surface_add_vertex(points[i])
    mesh.surface_end()
    mesh_instance.mesh = mesh
