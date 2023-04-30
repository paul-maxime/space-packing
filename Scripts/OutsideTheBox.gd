extends Area2D

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node2D):
	if body.is_in_group("Item"):
		body.set_in_box(false)

func _on_body_exited(body: Node2D):
	if body.is_in_group("Item"):
		body.set_in_box(true)
	
