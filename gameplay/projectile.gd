class_name Projectile
extends Node2D
## Chama ("fire") ou Onda de Medo ("wave").
## - Chama: pode ser rebatida com o Escudo da Fé e passa a fazer dano aos inimigos.
## - Onda: vai pelo chão e NÃO se bloqueia; só se evita saltando.

var vel := Vector2.ZERO
var radius := 18.0
var hostile := true
var reflectable := true
var kind := "fire"

var _life := 7.0
var _t := 0.0


func _ready() -> void:
	add_to_group("projectiles")


func _process(delta: float) -> void:
	position += vel * delta
	_t += delta
	_life -= delta
	if _life <= 0.0:
		queue_free()
	queue_redraw()


func rect() -> Rect2:
	if kind == "wave":
		return Rect2(position.x - 24.0, position.y - 40.0, 48.0, 40.0)
	return Rect2(position.x - radius, position.y - radius, radius * 2.0, radius * 2.0)


func reflect() -> void:
	vel = Vector2(-vel.x * 1.3, 0.0)
	hostile = false


func _draw() -> void:
	var dir := signf(vel.x) if vel.x != 0.0 else -1.0
	if kind == "wave":
		Art.shockwave(self, dir, _t)
	else:
		Art.fireball(self, dir, _t, radius, not hostile)
