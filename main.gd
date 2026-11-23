extends Node
## Gestor de ecrãs. É o ÚNICO nó que está na cena principal (main.tscn).
## Para mudar de ecrã, qualquer ecrã emite o sinal `navigate("nome")` e o Main trata do resto.
## Para adicionar um ecrã/nível novo: crie o .gd e registe-o aqui em SCREENS.

const SCREENS := {
	"splash": "res://screens/splash.gd",
	"menu": "res://screens/menu.gd",
	"level_select": "res://screens/level_select.gd",
	"settings": "res://screens/settings.gd",
	"faq": "res://screens/faq.gd",
	"armor": "res://screens/armor.gd",
	"level_1": "res://levels/level_1.gd",
}

var _current: Node = null


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#0d0820"))
	go("splash")


func go(target: String) -> void:
	get_tree().paused = false
	if not SCREENS.has(target):
		push_error("Ecrã desconhecido: " + target)
		return
	if _current != null:
		_current.queue_free()
		_current = null
	var script: GDScript = load(SCREENS[target])
	_current = script.new()
	_current.navigate.connect(go)
	add_child(_current)
