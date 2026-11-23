extends Screen
## Seleção de níveis. Só o nível 1 começa aberto; os outros abrem à medida que o jogador vence.

## Níveis que já têm jogo feito. Quando o nível 2 estiver pronto, juntem o 2 aqui.
const IMPLEMENTED := [1]


func build() -> void:
	use_backdrop(0.35)
	var col := make_column(22)
	col.add_child(UIKit.label(GameState.t("select_level"), 64, UIKit.GOLD))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 28)
	col.add_child(row)
	for lv in Bible.LEVELS:
		row.add_child(_make_card(lv))

	var back := UIKit.button(GameState.t("back"), Vector2(280, 64), Color("#c9c3dd"))
	back.pressed.connect(go.bind("menu"))
	col.add_child(back)


func _make_card(lv: Dictionary) -> Control:
	var id: int = lv["id"]
	var unlocked := id <= GameState.unlocked_levels
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(360, 400)
	panel.add_theme_stylebox_override("panel", UIKit.style(Color(0.08, 0.05, 0.2, 0.82) if unlocked else Color(0.08, 0.08, 0.12, 0.8), 22))
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(box)

	var tint := UIKit.GOLD if unlocked else Color(0.6, 0.6, 0.7)
	box.add_child(UIKit.label("%s %d" % [GameState.t("level"), id], 28, tint))
	box.add_child(UIKit.label(str(lv["name"]), 38, Color.WHITE if unlocked else Color(0.7, 0.7, 0.75), 310.0))
	box.add_child(UIKit.label(str(lv["place"]), 24, Color("#ffeec2") if unlocked else Color(0.55, 0.55, 0.6), 310.0))
	box.add_child(UIKit.label(str(lv["ref"]), 22, Color(1, 1, 1, 0.7)))

	var btn: Button
	if not unlocked:
		btn = UIKit.button(GameState.t("locked"), Vector2(300, 64))
		btn.disabled = true
	elif IMPLEMENTED.has(id):
		btn = UIKit.button(GameState.t("play"), Vector2(300, 64))
		btn.pressed.connect(go.bind("level_%d" % id))
	else:
		btn = UIKit.button(GameState.t("soon"), Vector2(300, 64), Color("#9fd3ff"))
		btn.pressed.connect(toast.bind(GameState.t("soon_toast")))
	box.add_child(btn)
	return panel
