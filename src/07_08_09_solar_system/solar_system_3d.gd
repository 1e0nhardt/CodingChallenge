extends Node3D


@onready var planet_3d: MeshInstance3D = $Planet3D


func _ready() -> void:
    planet_3d.spawn_moons(3, 1)
    
    # https://github.com/godotengine/godot-proposals/issues/1625
    # var bump_map = Image.new()
    # bump_map.load("res://src/07_08_09_solar_system/earthbump1k.jpg")
    # bump_map.bump_map_to_normal_map()
    # bump_map.save_png("res://src/07_08_09_solar_system/earthbump1k_normal.png")
