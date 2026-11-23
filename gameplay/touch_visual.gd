class_name TouchVisual
extends Node2D
## Desenho de um botão de toque (o TouchScreenButton só trata do toque, não desenha nada).

var radius := 70.0
var label := ""
var held := false


func set_held(value: bool) -> void:
	held = value
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color(1, 1, 1, 0.5 if held else 0.26))
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 40, Color(1, 1, 1, 0.7), 4.0)
	var size := 52 if label.length() == 1 else 24
	draw_string(ThemeDB.fallback_font, Vector2(-radius, float(size) * 0.35), label,
		HORIZONTAL_ALIGNMENT_CENTER, radius * 2.0, size, Color(0.1, 0.05, 0.2))
