extends Button

var audio_on_icon = preload("res://Assets/Images/AudioOn.png")
var audio_off_icon = preload("res://Assets/Images/AudioOff.png")

func _ready():
	connect("pressed", _on_button_pressed)
	_update_icon()

func _on_button_pressed():
	var master_bus = AudioServer.get_bus_index("Master")
	var is_muted = AudioServer.is_bus_mute(master_bus)
	AudioServer.set_bus_mute(master_bus, !is_muted)
	_update_icon()

func _update_icon():
	var master_bus = AudioServer.get_bus_index("Master")
	var is_muted = AudioServer.is_bus_mute(master_bus)
	self.icon = audio_off_icon if is_muted else audio_on_icon
