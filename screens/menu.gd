extends Screen
## Menu principal.


func build() -> void:
	use_backdrop(0.55)
	var hero := ValenteFrames.make_sprite(1.3)   # o herói, animado com os sprites
	hero.position = Vector2(190, 620)
	add_child(hero)

	var col := make_column(14)
	col.add_child(UIKit.label("O VALENTE", 100, UIKit.GOLD))
	col.add_child(UIKit.label(GameState.t("tagline"), 26, Color("#ffeec2")))
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 14)
	col.add_child(gap)
	_add_button(col, "play", "level_select")
	_add_button(col, "armor", "armor")
	_add_button(col, "settings", "settings")
	_add_button(col, "faq", "faq")


func _add_button(parent: Control, key: String, target: String) -> void:
	var b := UIKit.button(GameState.t(key), Vector2(360, 68))
	b.pressed.connect(go.bind(target))
	parent.add_child(b)
