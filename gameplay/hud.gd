class_name Hud
extends Control
## Interface durante o jogo: corações, barra de vida do boss, mensagens e botão de pausa.

signal pause_pressed

var hp := 5
var max_hp := 5
var boss_visible := false
var boss_hp := 8
var boss_max := 8
var boss_name := "Gigante da Sombra"

var _banner: Label
var _queue: Array = []
var _banner_time := 0.0


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_banner = UIKit.label("", 26, Color.WHITE, 0.0)
	_banner.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_banner.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_banner.add_theme_stylebox_override("normal", UIKit.style(Color(0.05, 0.03, 0.12, 0.8), 16))
	_banner.position = Vector2(190, 84)
	_banner.size = Vector2(900, 120)
	_banner.modulate.a = 0.0
	add_child(_banner)
	var pause_btn := UIKit.button("II", Vector2(76, 60), Color("#c9c3dd"))
	pause_btn.position = Vector2(1182, 18)
	pause_btn.pressed.connect(func() -> void: pause_pressed.emit())
	add_child(pause_btn)


## Mostra uma mensagem no topo. `urgent` interrompe a que estiver a aparecer.
func say(text: String, secs: float = 4.0, urgent: bool = false) -> void:
	if urgent:
		_queue.clear()
		_banner_time = 0.0
	_queue.append([text, secs])


func _process(delta: float) -> void:
	queue_redraw()
	if _banner_time > 0.0:
		_banner_time -= delta
		_banner.modulate.a = clampf(_banner_time / 0.4, 0.0, 1.0)
	elif not _queue.is_empty():
		var item: Array = _queue.pop_front()
		_banner.text = str(item[0])
		_banner_time = float(item[1])
		_banner.modulate.a = 1.0
	else:
		_banner.modulate.a = 0.0


func _draw() -> void:
	for i in max_hp:
		Art.heart(self, Vector2(44.0 + i * 54.0, 44.0), 20.0, i < hp)
	if boss_visible:
		var w := 520.0
		var x := (1280.0 - w) / 2.0
		draw_rect(Rect2(x - 4.0, 26.0, w + 8.0, 34.0), Color(0, 0, 0, 0.65))
		draw_rect(Rect2(x, 30.0, w * float(boss_hp) / float(boss_max), 26.0), Color("#c0392b"))
		draw_string(ThemeDB.fallback_font, Vector2(x, 20.0), boss_name,
			HORIZONTAL_ALIGNMENT_CENTER, w, 22, Color.WHITE)
