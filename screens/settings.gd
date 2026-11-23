extends Screen
## Definições: som, idioma e apagar progresso.

var _sound_btn: Button
var _reset_armed := false


func build() -> void:
	use_backdrop(0.4)
	var col := make_column(20)
	col.add_child(UIKit.label(GameState.t("settings"), 64, UIKit.GOLD))

	_sound_btn = UIKit.button("", Vector2(560, 68))
	_sound_btn.pressed.connect(_toggle_sound)
	col.add_child(_sound_btn)
	_refresh_sound()

	var lang := UIKit.button("%s: %s" % [GameState.t("language"), GameState.t("lang_name")], Vector2(560, 68))
	lang.pressed.connect(_toggle_language)
	col.add_child(lang)

	var reset := UIKit.button(GameState.t("reset"), Vector2(560, 68), Color("#ff9a8a"))
	reset.pressed.connect(_on_reset.bind(reset))
	col.add_child(reset)

	var back := UIKit.button(GameState.t("back"), Vector2(280, 64), Color("#c9c3dd"))
	back.pressed.connect(go.bind("menu"))
	col.add_child(back)


func _refresh_sound() -> void:
	var state := GameState.t("on") if GameState.sound_on else GameState.t("off")
	_sound_btn.text = "%s: %s" % [GameState.t("sound"), state]


func _toggle_sound() -> void:
	GameState.sound_on = not GameState.sound_on
	GameState.save_game()
	_refresh_sound()


func _toggle_language() -> void:
	GameState.language = "en" if GameState.language == "pt" else "pt"
	GameState.save_game()
	go("settings")   # recarrega este ecrã com o novo idioma


func _on_reset(btn: Button) -> void:
	if not _reset_armed:
		_reset_armed = true
		btn.text = GameState.t("reset_confirm")
		return
	GameState.reset_progress()
	_reset_armed = false
	btn.text = GameState.t("reset")
