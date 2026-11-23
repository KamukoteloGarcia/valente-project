extends Node
## Estado global (autoload "GameState"): progresso, definições e gravação em disco.

const SAVE_PATH := "user://o_valente.cfg"

var unlocked_levels: int = 1      # o jogo começa só com o nível 1 aberto
var armor: Array = []             # ids das peças ganhas, ex.: "escudo"
var sound_on: bool = true
var language: String = "pt"


func _ready() -> void:
	_register_input_actions()
	load_game()


## Cria as ações de teclado por código (assim não há que mexer no Mapa de Entrada).
func _register_input_actions() -> void:
	_add_action("mover_esq", [KEY_LEFT, KEY_A])
	_add_action("mover_dir", [KEY_RIGHT, KEY_D])
	_add_action("pular", [KEY_SPACE, KEY_W, KEY_UP])
	_add_action("escudo", [KEY_J, KEY_X, KEY_K])


func _add_action(action: String, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for k in keys:
		var ev := InputEventKey.new()
		ev.physical_keycode = k as Key
		InputMap.action_add_event(action, ev)


## Texto traduzido. Ex.: GameState.t("play")
func t(key: String) -> String:
	return Strings.get_text(language, key)


func complete_level(level: int, armor_id: String) -> void:
	unlocked_levels = maxi(unlocked_levels, level + 1)
	if armor_id != "" and not armor.has(armor_id):
		armor.append(armor_id)
	save_game()


func reset_progress() -> void:
	unlocked_levels = 1
	armor = []
	save_game()


func save_game() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "unlocked_levels", unlocked_levels)
	cfg.set_value("progress", "armor", armor)
	cfg.set_value("settings", "sound_on", sound_on)
	cfg.set_value("settings", "language", language)
	cfg.save(SAVE_PATH)


func load_game() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	unlocked_levels = int(cfg.get_value("progress", "unlocked_levels", 1))
	armor = cfg.get_value("progress", "armor", [])
	sound_on = bool(cfg.get_value("settings", "sound_on", true))
	language = str(cfg.get_value("settings", "language", "pt"))
