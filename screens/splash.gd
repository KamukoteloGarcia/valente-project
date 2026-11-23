extends Screen
## Ecrã de abertura: logótipo a aparecer, depois segue para o menu (ou toque para saltar).

var _gone := false


func build() -> void:
	use_backdrop(0.15)
	var col := make_column(10)
	col.add_child(UIKit.label("O VALENTE", 112, UIKit.GOLD))
	col.add_child(UIKit.label("Projeto Vamos à Arca", 36, Color("#ffeec2")))
	col.add_child(UIKit.label("Radical Dev", 26, Color(1, 1, 1, 0.75)))
	col.modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(col, "modulate:a", 1.0, 1.0)
	tw.tween_interval(1.6)
	tw.tween_callback(_leave)


func _leave() -> void:
	if _gone:
		return
	_gone = true
	go("menu")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_leave()
	elif event is InputEventScreenTouch and event.pressed:
		_leave()
