extends Node2D

var mesh: ImmediateMesh
var p_n: float = 2.0

func _ready():
    mesh = ImmediateMesh.new()
    $MeshInstance2D.mesh = mesh


func _process(delta: float) -> void:
    p_n += delta

    create_superellipse(
        100, 100, pingpong(fmod(p_n, 6.0), 3.0), 
        Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
    )



func create_superellipse(a: float, b: float, n: float, offset: Vector2) -> void:
    mesh.clear_surfaces()
    mesh.surface_begin(PrimitiveMesh.PRIMITIVE_LINE_STRIP)
    var angle = 0
    while angle < TAU:
        angle += 0.01
        var x = pow(abs(cos(angle)), 2.0/n) * a * sign(cos(angle)) + offset.x
        var y = pow(abs(sin(angle)), 2.0/n) * b * sign(sin(angle))  + offset.y
        mesh.surface_add_vertex_2d(Vector2(x, y))
    mesh.surface_end()


