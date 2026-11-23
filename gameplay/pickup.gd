class_name Pickup
extends Node2D
## Objeto apanhável: "escudo" (Escudo da Fé) ou "coracao" (recupera 1 vida).

var kind := "coracao"
var _t := 0.0


func _ready() -> void:
	add_to_group("pickups")
	_t = randf() * 3.0


func _process(delta: float) -> void:
	_t += delta
	queue_redraw()


func rect() -> Rect2:
	return Rect2(position.x - 30.0, position.y - 110.0, 60.0, 110.0)


func _draw() -> void:
	var bob := sin(_t * 3.0) * 8.0
	if kind == "escudo":
		for i in 3:
			draw_circle(Vector2(0, -62.0 + bob), 50.0 + i * 12.0, Color(1, 0.9, 0.4, 0.1))
		Art.shield(self, Vector2(0, -62.0 + bob), 30.0)
	else:
		Art.heart(self, Vector2(0, -60.0 + bob), 20.0, true)
