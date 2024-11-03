extends Control

const DROP = preload("res://src/05_space_invader/drop.tscn")
const FLOWER = preload("res://src/05_space_invader/flower.tscn")

var flower_count: int = 6
var drop_prototype

@onready var ship: Control = $Ship
@onready var flowers: Control = $Flowers
@onready var drops: Control = $Drops

func _ready() -> void:
    drop_prototype = DROP.instantiate()
    ship.position.x = size.x / 2
    ship.position.y = size.y - ship.size.y
    flowers.position.y = 5

    for i in range(flower_count):
        var flower = FLOWER.instantiate()
        flower.position = Vector2(5 + (flower.r * 2 + 10) * i, 0)
        flower.border_reached.connect(
            func():
                for child in flowers.get_children():
                    child.direction *= -1
                flowers.position.y += flowers.get_child(0).r * 2 + 5
        )
        flowers.add_child(flower)


func _process(delta: float) -> void:
    ship.move(delta)
    var flower_children = flowers.get_children()
    if flowers.get_child(0).direction < 0:
        flower_children.reverse()

    for child in flower_children:
        child.move(delta)
    
    for drop in drops.get_children():
        var collided_flower = drop.collide_with(flower_children)
        if collided_flower:
            collided_flower.grow()
            drop.queue_free()


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_right"):
        ship.direction = 1
    elif event.is_action_pressed("ui_left"):
        ship.direction = -1
    elif event.is_action_released("ui_right") or event.is_action_released("ui_left"):
        ship.direction = 0

    if event.is_action_released("ui_select"):
        var drop = drop_prototype.duplicate()
        drop.position = ship.position
        drop.position.y -= ship.ship_size.y / 2
        drops.add_child(drop)
