extends Node

@onready var timer : Timer = $Timer

const dataPath : String = "res://data/tv_events_cuisine.json"
const prefabNpcPath : String = "res://prefabScenes/npc/"
const startWaitDuration : int = 3
const stepDuration : int = 3

var npcChilds : Array = Array()
var currentStep : int = 0

var tvProgram : TvProgram
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var file = FileAccess.open(dataPath, FileAccess.READ)
	#retrieve jsontext
	var fileText = file.get_as_text();
	var json = JSON.new()
	var error = json.parse(fileText)
	
	if error == OK:
		tvProgram = TvProgram.new()
		var data_received = json.data
		for jsonStep in data_received.Steps:
			#first 2 step => difficulty 1
			var tvStep = TvStep.new()
			var happenings = Array()
			var jsonSoucis = jsonStep.Soucis
			var nbHappening = 1
			#3 -> 5 step => difficulty 2
			if jsonStep.Id > 2 && jsonStep.Id <= 5:
				nbHappening = 2
			#6 -> 7 step => difficulty 3
			elif jsonStep.Id > 5:
				nbHappening = 3
			for i in range(nbHappening):
				var index = randi_range(0,len(jsonSoucis) - 1)
				happenings.append(jsonToTvHappening(jsonSoucis[index]))
				jsonSoucis.remove_at(index)
			tvStep.happenings = happenings
			tvProgram.TvSteps.append(tvStep)
	timer.wait_time = startWaitDuration
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	if currentStep == 0:
		timer.wait_time = stepDuration
	else :
		for child in npcChilds:
			remove_child(child)
		var step = tvProgram.TvSteps[currentStep - 1]
		for happening in step.happenings:
			loadPrefab(happening.soucis)
			if happening.solution != null :
				loadPrefab(happening.solution)
	
	print("start timer step : " + str(currentStep))
	currentStep = currentStep + 1 
	if currentStep <= len(tvProgram.TvSteps):
		timer.start()
	else:
		print("end partie")
	

func jsonToTvHappening(json) -> TvHappening:
	var issue : TvEvent = TvEvent.new(json, true)
	var solution : TvEvent = null
	if json.Solution != null:
		solution = TvEvent.new(json.Solution, false)
	return TvHappening.new(issue, solution)

func loadPrefab(event : TvEvent) -> void:
	var prefabPath = getPrefabPath(event.spritePath)
	var issueScene : PackedScene = load(prefabPath)
	if issueScene != null:
		var issueChild = issueScene.instantiate()
		#issueChild.position = event.position
		npcChilds.append(issueChild)
		add_child(issueChild)

func getPrefabPath(name : String) -> String:
	var path : String = prefabNpcPath
	var zone : String = name.left(3)
	if zone == "CUI":
		path += "Cuisine/" + name.to_lower() + ".tscn"
	elif zone == "JTD":
		path += "Debat/" + name.to_lower() + ".tscn"
	elif zone == "TAS":
		path += "Talk Show/" + name.to_lower() + ".tscn"
	elif zone == "TF1":
		name = name.right(len(name)-3)
		path += "TF1/tf_1" + name.to_lower() + ".tscn"
	return path

class TvProgram:
	var TvSteps : Array
	
	func _init():
		TvSteps = Array()

class TvStep:
	var happenings : Array
	
	func _init():
		happenings = Array()

class TvHappening:
	var soucis : TvEvent
	var solution : TvEvent
	
	func _init(issue : TvEvent, solu : TvEvent):
		soucis = issue
		solution = solu

class TvEvent:
	var position : Vector3
	var spritePath : String
	var soundPath: String
	var isBad : bool
	
	func _init(json, bad : bool):
		position = Vector3(json.Coords.x, json.Coords.y, json.Coords.z)
		spritePath = json.Sprite_Path
		soundPath = json.Sound_Path
		isBad = bad

#	func _init(pos : Vector3, sprite : String, sound : String, bad : bool):
#		position = pos
#		spritePath = sprite
#		soundPath = sound
#		isBad = bad
	
