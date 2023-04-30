extends Node2D

var is_winning: bool = false
var has_won: bool = false
var winning_timer: float = 1.0

func _ready():
	load_next_level()

func _process(delta):
	process_winning_timer(delta)
	update_physics_ticks()

func load_next_level():
	pass

func check_if_winning():
	var items = get_tree().get_nodes_in_group("Item")
	is_winning = items.all(func(item): return item.is_in_box)

func process_winning_timer(delta: float):
	if has_won:
		return
	if is_winning:
		winning_timer -= delta
		if winning_timer < 0:
			has_won = true
			var items = get_tree().get_nodes_in_group("Item")
			items.map(func(item): item.freeze = true)
			$TadaAudioPlayer.play()
			$TadaParticles.emitting = true
	else:
		winning_timer = 1.0

func update_physics_ticks():
	var expected_ticks = clampi(int(Engine.get_frames_per_second()), 60, 240)
	if expected_ticks >= 58 and expected_ticks <= 62:
		expected_ticks = 60
	if expected_ticks >= 118 and expected_ticks <= 122:
		expected_ticks = 120
	if expected_ticks >= 142 and expected_ticks <= 146:
		expected_ticks = 144
	if expected_ticks >= 238 and expected_ticks <= 242:
		expected_ticks = 240
	if Engine.physics_ticks_per_second != expected_ticks:
		print("Switching physics ticks to " + str(expected_ticks))
		Engine.physics_ticks_per_second = expected_ticks	
