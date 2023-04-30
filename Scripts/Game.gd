extends Node2D

func _ready():
	pass

func _process(_delta):
	var expected_ticks = clampi(int(Engine.get_frames_per_second()), 60, 240)
	if Engine.physics_ticks_per_second != expected_ticks:
		print("Switching physics ticks to " + str(expected_ticks))
		Engine.physics_ticks_per_second = expected_ticks
