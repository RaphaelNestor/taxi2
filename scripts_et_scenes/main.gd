extends Node

var attente_max = 2
var attente_actuelle = 1
var duree_allume = 1
var niveau = 1
var allume = false

@export var del_eteint : Node
@export var del_allume : Node
@export var del_puni : Node

@export var diode : Node
@export var bouton : Node

@export var label_attente_act : Node
@export var label_attente_max : Node
@export var label_niv : Node
@export var label_direct : Node

@export var feedback_visuel : Node

func _ready() -> void:
	feedback_visuel.visible = false
	label_attente_max.text = "attente max : " + str(attente_max)
	label_attente_act.text = "attente actuelle : " + str(attente_actuelle)
	label_niv.text = "niveau : " + str(niveau)
	_eteindre_diode()

func _process(delta: float) -> void:
	if allume == true :
		label_direct.text = "allume : " + str("%0.2f" % del_allume.time_left)
	else :
		label_direct.text = "eteint : " + str("%0.2f" % del_eteint.time_left)

func _eteint_timeout() -> void:
	print("allume")
	allume = true
	diode.texture = load("res://assets/graph/diode_on.png")
	del_allume.wait_time = duree_allume
	del_allume.start()

func _allume_timeout() -> void:
	if niveau > 1:
		_decrementation_temps()
	_eteindre_diode()
	
func _eteindre_diode() -> void:
	print("eteint")
	allume = false
	diode.texture = load("res://assets/graph/diode_off.png")
	attente_actuelle =  randi_range(niveau, attente_max)
	del_eteint.wait_time = attente_actuelle
	label_attente_act.text = "attente actuelle : " + str(attente_actuelle)
	del_eteint.start()

func _on_bouton_pressed() -> void:
	if allume == true :
		del_allume.stop()
		print("appuye")
		label_niv.text = "niveau : " + str(niveau)
		_incrementation_temps()
		_eteindre_diode()
	else :
		feedback_visuel.texture = load("res://assets/graph/pas_content.png")
		feedback_visuel.visible = true
		var nouveau_temps = ceil(del_eteint.time_left + niveau)
		del_eteint.stop()
		del_eteint.wait_time = nouveau_temps
		del_eteint.start()
		label_attente_act.text = "attente actuelle : " + str(nouveau_temps)
		del_puni.start()
		

func _incrementation_temps() -> void:
	niveau += 1
	attente_max *= 2
	label_niv.text = "niveau : " + str(niveau)
	label_attente_max.text = "attente max : " + str(attente_max)
	duree_allume = ceil(duree_allume * 1.5)
	print("duree allume :" + str(duree_allume))
	
func _decrementation_temps() -> void:
	niveau -= 1
	attente_max /= 2
	label_niv.text = "niveau : " + str(niveau)
	label_attente_max.text = "attente max : " + str(attente_max)
	duree_allume = ceil(duree_allume / 1.5)
	print("duree allume :" + str(duree_allume))

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip"):
		del_eteint.wait_time = 1
		del_eteint.start()
		label_attente_act.text = "attente actuelle : 1"
	elif Input.is_action_just_pressed("bouton"):
		_on_bouton_pressed()


func _on_punition_timeout() -> void:
	feedback_visuel.visible = false
	pass # Replace with function body.
