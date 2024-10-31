extends Node3D

@export var use_optimized := true

var level: int = 0
var stop_ratate := false

@onready var box_anchor: Node3D = $BoxAnchor
@onready var multi_mesh_instance: MultiMeshInstance3D = $BoxAnchor/MultiMeshInstance3D


func _ready() -> void:
    if not use_optimized:
        multi_mesh_instance.queue_free()
        var box = MeshInstance3D.new()
        box.mesh = BoxMesh.new()
        box_anchor.add_child(box)
    else:
        multi_mesh_instance.multimesh.instance_count = 1
        multi_mesh_instance.multimesh.set_instance_transform(0, Transform3D())


func _process(delta: float) -> void:
    box_anchor.rotate(Vector3(1, 1, 1).normalized(), delta)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept"):
        if use_optimized:
            generate_optimized()
        else:
            generate()

    if event is InputEventMouseButton:
        event = event as InputEventMouseButton
        if event.button_index == MOUSE_BUTTON_WHEEL_UP:
            $Camera3D.position.z -= 0.1
        if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            $Camera3D.position.z += 0.1

    if event.is_action_pressed("ui_cancel"):
        stop_ratate = not stop_ratate
        set_process(not stop_ratate)


func generate() -> void:
    var boxes = box_anchor.get_children()
    var new_boxes = []
    for box in boxes:
        for x in range(-1, 2):
            for y in range(-1, 2):
                for z in range(-1, 2):
                    var sum = abs(x) + abs(y) + abs(z)
                    if sum > 1:
                        var new_box = box.duplicate()
                        new_box.scale *= 1.0/3.0
                        new_box.position = box.position + Vector3(x, y, z) * box.scale.x * box.mesh.size.x / 4.0
                        new_boxes.append(new_box)

    for box in boxes:
        box.queue_free()

    for box in new_boxes:
        box_anchor.add_child(box)


func generate_optimized() -> void:
    level += 1
    var old_poses = []
    for i in multi_mesh_instance.multimesh.instance_count:
        old_poses.append(multi_mesh_instance.multimesh.get_instance_transform(i))

    var multimesh := MultiMesh.new()
    multimesh.transform_format = MultiMesh.TRANSFORM_3D
    multimesh.mesh = BoxMesh.new()
    multimesh.instance_count = int(pow(20, level))

    for i in old_poses.size():
        var old_pos = old_poses[i]
        var j = 0
        for x in range(-1, 2):
            for y in range(-1, 2):
                for z in range(-1, 2):
                    var sum = abs(x) + abs(y) + abs(z)
                    if sum > 1:
                        var pos = Transform3D(old_pos)
                        pos = pos.scaled(Vector3(1.0/3.0, 1.0/3.0, 1.0/3.0))
                        pos = pos.translated(Vector3(x, y, z) / 4.0)
                        multimesh.set_instance_transform(i * 20 + j, pos)
                        j += 1

    multi_mesh_instance.multimesh = multimesh
