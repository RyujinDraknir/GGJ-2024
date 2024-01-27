extends Node3D

const dataPath : String = "res://data/tv_events.json"
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
			else:
				nbHappening = 3
			for i in range(nbHappening):
				var index = randi_range(0,len(jsonSoucis) - 1)
				happenings.append(jsonToTvHappening(jsonSoucis[index]))
				jsonSoucis.remove_at(index)
			tvStep.happenings = happenings
			tvProgram.TvSteps.append(tvStep)
		print(tvProgram)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func jsonToTvHappening(json) -> TvHappening:
	var issue : TvEvent = TvEvent.new(json, true)
	var solution : TvEvent = null
	if json.Solution != null:
		solution = TvEvent.new(json.Solution, false)
	return TvHappening.new(issue, solution)

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
	
