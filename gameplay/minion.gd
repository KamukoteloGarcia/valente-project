class_name Minion
extends Node2D
## Sombra do Medo (capanga). Fica parada e atira chamas quando o jogador se aproxima.
## Morre se for pisada, tocada pelo escudo ou atingida por uma chama devolvida.

signal fire_requested(from: Vector2, vel: Vector2)

var player: Valente
var alive := true
var fire_interval := 2.8
var fire_speed := 300.0
var fire_range := 720.0

var _cool := 1.0
var _t := 0.0
var _charge := 0.0
var _dying := 0.0


func _ready() -> void:
	add_to_group("minions")
	_t = randf() * 5.0
	_cool = randf_range(0.6, fire_interval)


func _process(delta: float) -> void:
	_t += delta
	if not alive:
		_dying += delta * 3.0
		modulate.a = clampf(1.0 - _dying, 0.0, 1.0)
		scale = Vector2.ONE * (1.0 + _dying * 0.4)
		if _dying >= 1.0:
			queue_free()
		queue_redraw()
		return
	var dx := position.x - player.position.x
	if dx > 0.0 and dx < fire_range:
		_cool -= delta
		_charge = clampf(1.0 - _cool / 0.6, 0.0, 1.0) if _cool < 0.6 else 0.0
		if _cool <= 0.0:
			_cool = fire_interval
			_charge = 0.0
			var h := 28.0 if randf() < 0.5 else 62.0      # chama baixa ou média
			fire_requested.emit(position + Vector2(-40.0, -h), Vector2(-fire_speed, 0.0))
	else:
		_charge = 0.0
	queue_redraw()


func _draw() -> void:
	Art.minion(self, _t, _charge)


func hurt_box() -> Rect2:
	return Rect2(position.x - 28.0, position.y - 64.0, 56.0, 64.0)


func die() -> void:
	if not alive:
		return
	alive = false
	remove_from_group("minions")
