extends Screen
## Armadura de Deus (Efésios 6): mostra as peças ganhas e o versículo de cada uma.


func build() -> void:
	use_backdrop(0.45)
	var col := make_column(14)
	col.add_child(UIKit.label(GameState.t("armor_title"), 60, UIKit.GOLD))
	col.add_child(UIKit.label("Efésios 6:10-18", 26, Color("#ffeec2")))

	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 18)
	grid.add_theme_constant_override("v_separation", 18)
	col.add_child(grid)
	for piece in Bible.ARMOR:
		grid.add_child(_make_card(piece))

	var back := UIKit.button(GameState.t("back"), Vector2(280, 64), Color("#c9c3dd"))
	back.pressed.connect(go.bind("menu"))
	col.add_child(back)


func _make_card(piece: Dictionary) -> Control:
	var owned := GameState.armor.has(piece["id"])
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(380, 190)
	var bg := Color(0.1, 0.18, 0.4, 0.88) if owned else Color(0.1, 0.1, 0.15, 0.8)
	panel.add_theme_stylebox_override("panel", UIKit.style(bg, 18))
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(box)
	if owned:
		box.add_child(UIKit.label(str(piece["name"]), 30, UIKit.GOLD, 340.0))
		box.add_child(UIKit.label(str(piece["ref"]), 22, Color("#9fd3ff")))
		box.add_child(UIKit.label(str(piece["text"]), 18, Color.WHITE, 340.0))
	else:
		box.add_child(UIKit.label("?", 56, Color(0.6, 0.6, 0.7)))
		var level := int(piece["level"])
		var hint := GameState.t("armor_locked") % level if level > 0 else GameState.t("armor_future")
		box.add_child(UIKit.label(hint, 24, Color(0.7, 0.7, 0.78)))
	return panel
