class_name UIKit
extends RefCounted
## Ferramentas para criar interface por código (botões, textos, painéis) sempre com o mesmo estilo.

const GOLD := Color("#f2c230")
const DARK := Color("#1b1233")


static func style(color: Color, radius: int = 18) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = color
	sb.set_corner_radius_all(radius)
	sb.content_margin_left = 24
	sb.content_margin_right = 24
	sb.content_margin_top = 10
	sb.content_margin_bottom = 10
	return sb


static func button(text: String, size: Vector2 = Vector2(320, 68), color: Color = GOLD) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = size
	b.add_theme_font_size_override("font_size", 30)
	b.add_theme_color_override("font_color", DARK)
	b.add_theme_color_override("font_hover_color", DARK)
	b.add_theme_color_override("font_pressed_color", DARK)
	b.add_theme_color_override("font_disabled_color", Color(1, 1, 1, 0.55))
	b.add_theme_stylebox_override("normal", style(color))
	b.add_theme_stylebox_override("hover", style(color.lightened(0.15)))
	b.add_theme_stylebox_override("pressed", style(color.darkened(0.2)))
	b.add_theme_stylebox_override("disabled", style(Color(0.3, 0.3, 0.4, 0.85)))
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	b.pressed.connect(func() -> void: Sfx.play("click"))
	return b


static func label(text: String, font_size: int = 28, color: Color = Color.WHITE, wrap_width: float = 0.0) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.6))
	l.add_theme_constant_override("shadow_offset_x", 2)
	l.add_theme_constant_override("shadow_offset_y", 2)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if wrap_width > 0.0:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size.x = wrap_width
	return l
