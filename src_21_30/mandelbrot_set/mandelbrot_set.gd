extends TextureRect


func _process(_delta: float) -> void:
    var mouse_pos := get_local_mouse_position()
    mouse_pos /= get_viewport_rect().size

    material.set_shader_parameter("mouse_pos", mouse_pos)