extends Sprite2D

const STARS_SPEED = 100

var tween: Tween = null
var viewport_size: Vector2

func _ready():
	viewport_size = get_viewport_rect().end

func _process(delta):
	position += Vector2(-1.0, -0.3) * delta * STARS_SPEED
	if position.x < -10:
		position.x += viewport_size.x + 20
	if position.y < -10:
		position.y += viewport_size.y + 20
	
	if !tween or !tween.is_running():
		tween = create_tween()
		tween.tween_property(self, "modulate", Color.WHITE if modulate == Color.TRANSPARENT else Color.TRANSPARENT, randf_range(0.5, 2.0)).set_trans(Tween.TRANS_SINE)
