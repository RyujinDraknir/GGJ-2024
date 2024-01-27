extends Node

var bad : bool
var neutral : bool
var good : bool

func _ready():
	bad = false
	neutral = true
	good = false

func state_is_bad():
	bad = true
	neutral = false
	good = false

func state_is_neutral():
	bad = false
	neutral = true
	good = false

func state_is_good():
	bad = false
	neutral = false
	good = true
