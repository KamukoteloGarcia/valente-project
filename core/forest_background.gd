class_name ForestBackground
extends Node2D
## Fundo da floresta com paralaxe. `progress` vai de 0 (noite / medo) a 1 (amanhecer / coragem).

var cam_x := 0.0
var progress := 0.0


func _draw() -> void:
	var top := Color("#120c28").lerp(Color("#4a86d4"), progress)
	var bottom := Color("#3d2858").lerp(Color("#ffd9a0"), progress)
	draw_polygon(
		PackedVector2Array([Vector2(0, 0), Vector2(1280, 0), Vector2(1280, 720), Vector2(0, 720)]),
		PackedColorArray([top, top, bottom, bottom]))
	var star_a := clampf(1.0 - progress * 2.2, 0.0, 1.0)
	if star_a > 0.0:
		for i in 40:
			var sx := fposmod(float(i) * 197.0, 1280.0)
			var sy := fposmod(float(i) * 83.0, 330.0)
			draw_circle(Vector2(sx, sy), 1.5 + float(i % 3) * 0.5, Color(1, 1, 0.9, star_a * 0.8))
	var body_pos := Vector2(1010.0, lerpf(230.0, 170.0, progress))
	var body_col := Color("#dfe3f5").lerp(Color("#fff0a8"), progress)
	draw_circle(body_pos, 90.0, Color(body_col.r, body_col.g, body_col.b, 0.15))
	draw_circle(body_pos, 56.0, body_col)
	_ridge(0.08, 470.0, 90.0, Color("#241b3d").lerp(Color("#6f8fb8"), progress))
	_ridge(0.16, 520.0, 70.0, Color("#1a1430").lerp(Color("#4f7d6a"), progress))
	_pines(0.35, 610.0, 190.0, Color("#120d22").lerp(Color("#2f6a47"), progress), 170.0)
	_pines(0.6, 640.0, 260.0, Color("#0c0818").lerp(Color("#245238"), progress), 240.0)


func _ridge(speed: float, base_y: float, amp: float, col: Color) -> void:
	var pts := PackedVector2Array()
	pts.append(Vector2(0, 720))
	var x := 0.0
	while x <= 1300.0:
		var wx := (x + cam_x * speed) * 0.006
		var y := base_y - (sin(wx) * 0.6 + sin(wx * 2.3 + 1.7) * 0.4 + 1.0) * amp * 0.5
		pts.append(Vector2(x, y))
		x += 40.0
	pts.append(Vector2(1300, 720))
	draw_colored_polygon(pts, col)


func _pines(speed: float, base_y: float, h: float, col: Color, spacing: float) -> void:
	var shift := cam_x * speed
	var first := int(floor(shift / spacing))
	var offset := fposmod(shift, spacing)
	for i in range(-1, int(1400.0 / spacing) + 2):
		var x := float(i) * spacing - offset
		var idx := first + i
		var hh := h * (0.8 + 0.4 * fposmod(float(idx) * 0.37, 1.0))
		for layer in 3:
			var ly := base_y - float(layer) * hh * 0.28
			var w := hh * (0.34 - float(layer) * 0.07)
			draw_colored_polygon(PackedVector2Array([
				Vector2(x - w, ly), Vector2(x + w, ly), Vector2(x, ly - hh * 0.42)]), col)
