extends Node2D

var attente_max = 30
var attente_actuelle = 3
var duree_allume = 1
var niveau = 1
var allume = false

@export var del_eteint : Node
@export var del_allume : Node
@export var diode : Node
@export var bouton : Node

func _ready() -> void:
	del_eteint.wait_time = randi_range(30, attente_max)
	del_eteint.start()

func _process(delta: float) -> void:
	pass

func _on_attente_timeout() -> void:
	var allume = true
	del_allume.wait_time = duree_allume
	del_allume.start()

func _on_allume_timeout() -> void:
	var allume = false
	del_eteint.wait_time = randi_range(30, attente_max)
	del_eteint.start()
