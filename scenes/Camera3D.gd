extends Camera3D

func _process(delta):
	self.rotation.y -= 0.115*delta
