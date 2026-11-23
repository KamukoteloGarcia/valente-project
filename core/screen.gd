class_name Screen
extends Control
## Base de todos os ecrãs de menu. Cada ecrã só precisa de escrever a função build().
## Para mudar de ecrã: go("nome_do_ecra")  (os nomes estão em main.gd).

signal navigate(target: String)

var backdrop: ForestBackground = null


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	build()


func build() -> void:
	pass


func go(target: String) -> void:
	navigate.emit(target)


func use_backdrop(progress: float = 0.5) -> void:
	backdrop = ForestBackground.new()
	backdrop.progress = progress
	add_child(backdrop)


func _process(delta: float) -> void:
	if backdrop != null:
		backdrop.cam_x += delta * 40.0
		backdrop.queue_redraw()


## Cria uma coluna centrada no ecrã e devolve-a para lhe juntarmos botões e textos.
func make_column(separation: int = 16) -> VBoxContainer:
	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", separation)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(box)
	return box


## Mensagem rápida no fundo do ecrã.
func toast(msg: String) -> void:
	var l := UIKit.label(msg, 28, Color.WHITE, 700.0)
	l.add_theme_stylebox_override("normal", UIKit.style(Color(0, 0, 0, 0.78), 14))
	add_child(l)
	l.position = Vector2(290, 630)
	var tw := create_tween()
	tw.tween_interval(1.6)
	tw.tween_property(l, "modulate:a", 0.0, 0.5)
	tw.tween_callback(l.queue_free)
