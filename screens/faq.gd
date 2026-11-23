extends Screen
## FAQ: perguntas, respostas e colaboradores. O conteúdo está em data/faq_data.gd.


func build() -> void:
	use_backdrop(0.4)
	var col := make_column(14)
	col.add_child(UIKit.label(GameState.t("faq_title"), 60, UIKit.GOLD))

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(1120, 470)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	col.add_child(scroll)

	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 12)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)

	for item in FaqData.FAQ:
		list.add_child(_make_entry(str(item[0]), str(item[1])))

	var credits := PanelContainer.new()
	credits.add_theme_stylebox_override("panel", UIKit.style(Color(0.2, 0.12, 0.35, 0.85), 16))
	var cbox := VBoxContainer.new()
	credits.add_child(cbox)
	cbox.add_child(_left_label("Colaboradores", 30, UIKit.GOLD))
	for line in FaqData.CREDITS:
		cbox.add_child(_left_label(str(line), 24, Color.WHITE))
	list.add_child(credits)

	var back := UIKit.button(GameState.t("back"), Vector2(280, 64), Color("#c9c3dd"))
	back.pressed.connect(go.bind("menu"))
	col.add_child(back)


func _make_entry(q: String, a: String) -> Control:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UIKit.style(Color(0.06, 0.04, 0.16, 0.85), 16))
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	panel.add_child(box)
	box.add_child(_left_label(q, 30, UIKit.GOLD))
	box.add_child(_left_label(a, 24, Color("#f4efff")))
	return panel


func _left_label(text: String, size: int, color: Color) -> Label:
	var l := UIKit.label(text, size, color, 1030.0)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	return l
