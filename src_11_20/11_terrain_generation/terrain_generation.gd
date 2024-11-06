extends Node3D

@onready var terrain: MeshInstance3D = $Terrain

var terrian_size := Vector2(1400, 1000)
var grid_width := 20
var cols: int = 0
var rows: int = 0
var time: float = 0.0

var noise_map: FastNoiseLite = FastNoiseLite.new()


func _ready():
    get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
    
    cols = int(terrian_size.x / grid_width)
    rows = int(terrian_size.y / grid_width)

    noise_map.noise_type = FastNoiseLite.TYPE_PERLIN
    noise_map.fractal_octaves = 5
    noise_map.fractal_lacunarity = 1.0
    noise_map.fractal_gain = 0.5
    noise_map.frequency = 0.1
    noise_map.seed = 1337


func _process(delta: float) -> void:
    time += delta
    generate_terrain_immediate()


# ArrayMesh最好使用三角形基元
func generate_terrain():
    var mesh = ArrayMesh.new()
    var surface_array = []
    surface_array.resize(Mesh.ARRAY_MAX)

    var verts = PackedVector3Array()
    for y in range(rows - 1):
        for x in range(cols):
            var h1 = Util.map(noise_map.get_noise_2d(x, (y+1) + time), -1, 1, -200, 200)
            var h2 = Util.map(noise_map.get_noise_2d(x, y + time), -1, 1, -200, 200)
            verts.append(Vector3(x * grid_width, h1, (y + 1) * grid_width))
            verts.append(Vector3(x * grid_width, h2, y * grid_width))

    surface_array[Mesh.ARRAY_VERTEX] = verts

    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, surface_array)
    terrain.mesh = mesh


func generate_terrain_immediate():
    var mesh = ImmediateMesh.new()
    for y in range(rows - 1):
        mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
        for x in range(cols):
            var h1 = Util.map(noise_map.get_noise_2d(x, (y+1) - time), -1, 1, -200, 200)
            var h2 = Util.map(noise_map.get_noise_2d(x, y - time), -1, 1, -200, 200)
            mesh.surface_add_vertex(Vector3(x * grid_width, h1, (y + 1) * grid_width))
            mesh.surface_add_vertex(Vector3(x * grid_width, h2, y * grid_width))
        mesh.surface_end()
    terrain.mesh = mesh
