extends RigidBody2D

const max_width = 1152
const max_height = 648
const draging_speed = 20

var is_picked = false
var picked_at = Vector2.ZERO

func _ready():
	connect("input_event", _on_input_event)
	connect("sleeping_state_changed", _on_sleeping_state_changed)
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	connect("body_entered", _on_body_entered)

func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_body_entered(body):
	if body.is_in_group("Item"):
		$ContactAudioPlayer.play()

func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and !is_picked:
		picked_at = get_global_mouse_position() - position
		self.angular_velocity = 0
		self.sleeping = false
		is_picked = true

func _on_sleeping_state_changed():
	if is_picked and self.sleeping:
		self.sleeping = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.is_pressed() and is_picked:		
		is_picked = false

func _integrate_forces(state):
	if state.transform.origin.x < -100:
		state.transform.origin.x = max_width + 100
	if state.transform.origin.y < -100:
		state.transform.origin.y = max_height + 100
	if state.transform.origin.x > max_width + 100:
		state.transform.origin.x = -100
	if state.transform.origin.y > max_height + 100:
		state.transform.origin.y = -100
	if not is_picked:
		return
	var target = get_global_mouse_position() - picked_at
	if target.x < 0: target.x = 0
	if target.y < 0: target.y = 0
	if target.x > max_width: target.x = max_width
	if target.y > max_height: target.y = max_height
	var movement = target - state.transform.origin
	state.linear_velocity = movement * draging_speed / self.mass

var is_in_box: bool = false
var next_in_box: bool = false
var current_tween = null

func set_in_box(in_box: bool):
	next_in_box = in_box
	await get_tree().create_timer(0.01).timeout
	if is_in_box == next_in_box:
		return
	is_in_box = next_in_box
	if in_box:
		if current_tween:
			current_tween.kill()
		current_tween = create_tween()
		current_tween.tween_property($Sprite2D, "modulate", Color.GREEN, 0.05)
		current_tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.5)
		get_node("/root/Game/SuccessAudioPlayer").play()
	else:
		if current_tween:
			current_tween.kill()
		current_tween = create_tween()
		current_tween.tween_property($Sprite2D, "modulate", Color.RED, 0.05)
		current_tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.5)
		get_node("/root/Game/FailAudioPlayer").play()
	get_node("/root/Game").check_if_winning()
