extends Node

@onready var player_hud = $"../PlayerHUD"

@export var audimat_bad : Sprite2D
@export var audimat_neutral : Sprite2D
@export var audimat_good :  Sprite2D

var bad : bool
var neutral : bool
var good : bool


func _ready():
	bad = false
	neutral = true
	good = false
	
	audimat_bad = player_hud.get_child(2).get_child(2)
	audimat_neutral = player_hud.get_child(2).get_child(4)
	audimat_good = player_hud.get_child(2).get_child(3)
	audimat_bad.hide()
	audimat_neutral.show()
	audimat_good.hide()

func state_is_bad():
	bad = true
	neutral = false
	good = false
	
	audimat_bad.show()
	audimat_neutral.hide()
	audimat_good.hide()

func state_is_neutral():
	bad = false
	neutral = true
	good = false
	
	audimat_bad.hide()
	audimat_neutral.show()
	audimat_good.hide()

func state_is_good():
	bad = false
	neutral = false
	good = true
	
	audimat_bad.hide()
	audimat_neutral.hide()
	audimat_good.show()
