extends Sprite2D

var direction = 1

func _process(delta):
	rotation += delta * 0.005 * direction
	if rotation > 0.03 and direction > 0:
		direction = -1
	if rotation < -0.03 and direction < 0:
		direction = 1
