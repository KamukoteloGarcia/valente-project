class_name Art
extends RefCounted
## Todos os desenhos do jogo (sprites feitos em código).
## Cada função recebe o CanvasItem onde desenhar e só pode ser chamada dentro de um _draw().
## A origem (0,0) de cada personagem fica nos PÉS.

const SKIN := Color("#8d5a37")
const HAIR := Color("#1d1410")
const TUNIC := Color("#2f6fb5")
const GOLD := Color("#f2c230")


static func _v(f: float, x: float, y: float) -> Vector2:
	return Vector2(x * f, y)


## O Valente. f = direção (1 direita, -1 esquerda).
static func valente(ci: CanvasItem, f: float, t: float, moving: bool, in_air: bool, has_shield: bool, shield_up: bool) -> void:
	var swing := 0.0
	if in_air:
		swing = 0.55
	elif moving:
		swing = sin(t * 14.0) * 0.7
	var hip := Vector2(0, -40)
	var leg_col := Color("#5b3a21")
	var foot_a := hip + Vector2(sin(swing) * 24.0 * f, 38.0)
	var foot_b := hip + Vector2(-sin(swing) * 24.0 * f, 38.0)
	# escudo às costas (quando não está levantado)
	if has_shield and not shield_up:
		shield(ci, _v(f, -16.0, -62.0), 20.0)
	# pernas e sandálias
	ci.draw_line(hip, foot_b, leg_col, 10.0)
	ci.draw_line(hip, foot_a, leg_col, 10.0)
	ci.draw_circle(foot_b + _v(f, 3.0, 0.0), 7.0, Color("#a86b32"))
	ci.draw_circle(foot_a + _v(f, 3.0, 0.0), 7.0, Color("#a86b32"))
	# braço de trás
	ci.draw_line(_v(f, -12.0, -72.0), _v(f, -20.0, -52.0 + sin(swing) * 6.0), SKIN, 8.0)
	# túnica
	ci.draw_colored_polygon(PackedVector2Array([
		_v(f, -15.0, -80.0), _v(f, 15.0, -80.0), _v(f, 20.0, -38.0), _v(f, -20.0, -38.0)]), TUNIC)
	ci.draw_line(_v(f, -19.0, -43.0), _v(f, 19.0, -43.0), GOLD, 7.0)
	# cabeça
	ci.draw_circle(_v(f, 0.0, -95.0), 17.0, HAIR)
	ci.draw_circle(_v(f, 3.0, -90.0), 13.5, SKIN)
	ci.draw_line(_v(f, -14.0, -100.0), _v(f, 16.0, -104.0), Color("#d94a3a"), 5.0)
	ci.draw_circle(_v(f, 8.0, -92.0), 4.5, Color.WHITE)
	ci.draw_circle(_v(f, 9.5, -92.0), 2.4, Color.BLACK)
	ci.draw_line(_v(f, 5.0, -83.0), _v(f, 11.0, -84.0), Color("#3a1d0e"), 2.0)
	# braço da frente + escudo levantado
	if shield_up:
		ci.draw_line(_v(f, 12.0, -72.0), _v(f, 32.0, -62.0), SKIN, 8.0)
		shield(ci, _v(f, 38.0, -62.0), 28.0)
	else:
		ci.draw_line(_v(f, 12.0, -72.0), _v(f, 22.0, -52.0 - sin(swing) * 6.0), SKIN, 8.0)


## Escudo da Fé (dourado, azul e cruz branca).
static func shield(ci: CanvasItem, pos: Vector2, r: float) -> void:
	ci.draw_circle(pos, r, GOLD)
	ci.draw_circle(pos, r * 0.82, TUNIC)
	ci.draw_line(pos + Vector2(0, -r * 0.6), pos + Vector2(0, r * 0.6), Color.WHITE, r * 0.18)
	ci.draw_line(pos + Vector2(-r * 0.45, -r * 0.1), pos + Vector2(r * 0.45, -r * 0.1), Color.WHITE, r * 0.18)


## Sombra do Medo (capanga). Olha sempre para a esquerda (para o jogador).
static func minion(ci: CanvasItem, t: float, charge: float) -> void:
	var bob := sin(t * 4.0) * 3.0
	var body := Color("#3a2858")
	ci.draw_circle(Vector2(0, -34 + bob), 32.0, body)
	for i in 5:
		ci.draw_circle(Vector2(-24.0 + i * 12.0, -8.0 + sin(t * 6.0 + i) * 3.0), 10.0, body)
	ci.draw_circle(Vector2(-12, -42 + bob), 9.0, Color("#f6e27a"))
	ci.draw_circle(Vector2(12, -42 + bob), 9.0, Color("#f6e27a"))
	ci.draw_circle(Vector2(-15, -42 + bob), 4.0, Color.BLACK)
	ci.draw_circle(Vector2(9, -42 + bob), 4.0, Color.BLACK)
	ci.draw_line(Vector2(-22, -56 + bob), Vector2(-4, -50 + bob), Color.BLACK, 4.0)
	ci.draw_line(Vector2(22, -56 + bob), Vector2(4, -50 + bob), Color.BLACK, 4.0)
	if charge > 0.0:
		ci.draw_circle(Vector2(-38, -40 + bob), 6.0 + charge * 12.0, Color(1.0, 0.55, 0.1, 0.9))


## Chamas (vermelhas) ou luz da fé (azul, quando devolvidas com o escudo).
static func fireball(ci: CanvasItem, dir: float, t: float, r: float, friendly: bool) -> void:
	var outer := Color("#e5391b")
	var mid := Color("#ff9a1f")
	var core := Color("#fff2a0")
	if friendly:
		outer = Color("#2f8fff")
		mid = Color("#7fd6ff")
		core = Color.WHITE
	for i in 4:
		var k := float(i)
		ci.draw_circle(Vector2(-dir * k * r * 0.7, 0), r * (1.0 - k * 0.18), Color(outer.r, outer.g, outer.b, 0.5 - k * 0.1))
	ci.draw_circle(Vector2.ZERO, r, outer)
	ci.draw_circle(Vector2.ZERO, r * 0.7, mid)
	ci.draw_circle(Vector2.ZERO, r * 0.4 + sin(t * 20.0) * 1.5, core)


## Onda de Medo (ataque especial do Gigante): vai pelo chão, só se evita saltando.
static func shockwave(ci: CanvasItem, dir: float, t: float) -> void:
	var c := Color("#7b2fd0")
	ci.draw_colored_polygon(PackedVector2Array([
		Vector2(-34 * dir, 0), Vector2(30 * dir, 0), Vector2(16 * dir, -22), Vector2(-4 * dir, -44 - sin(t * 18.0) * 4.0), Vector2(-20 * dir, -20)]), c)
	ci.draw_colored_polygon(PackedVector2Array([
		Vector2(-18 * dir, 0), Vector2(16 * dir, 0), Vector2(4 * dir, -24), Vector2(-8 * dir, -14)]), Color("#d9a8ff"))


## Gigante da Sombra (boss do nível 1). Olha para a esquerda.
static func boss(ci: CanvasItem, t: float, tele: float, hurt: float) -> void:
	var base := Color("#2a1840").lerp(Color("#9b1c1c"), tele)
	base = base.lerp(Color.WHITE, hurt * 0.8)
	var dark := base.darkened(0.35)
	for i in 3:
		ci.draw_circle(Vector2(0, -150), 190.0 + i * 28.0 + sin(t * 2.0 + i) * 6.0, Color(0.5, 0.2, 0.8, 0.06))
	ci.draw_rect(Rect2(-60, -70, 44, 70), dark)
	ci.draw_rect(Rect2(16, -70, 44, 70), dark)
	ci.draw_line(Vector2(62, -190), Vector2(105, -110), dark, 24.0)
	ci.draw_colored_polygon(PackedVector2Array([
		Vector2(-85, -60), Vector2(85, -60), Vector2(70, -190), Vector2(40, -225), Vector2(-40, -225), Vector2(-70, -190)]), base)
	var hand := Vector2(-118, -65 + sin(t * 3.0) * 6.0)
	ci.draw_line(Vector2(-62, -190), hand, base.lightened(0.1), 26.0)
	ci.draw_circle(hand, 20.0, base.lightened(0.1))
	ci.draw_circle(Vector2(0, -262), 50.0, base)
	ci.draw_colored_polygon(PackedVector2Array([Vector2(-42, -290), Vector2(-62, -352), Vector2(-14, -306)]), Color("#d9d0c0"))
	ci.draw_colored_polygon(PackedVector2Array([Vector2(42, -290), Vector2(62, -352), Vector2(14, -306)]), Color("#d9d0c0"))
	var eye := Color("#ffe24a").lerp(Color("#ff4a2b"), tele)
	ci.draw_circle(Vector2(-20, -268), 12.0, eye)
	ci.draw_circle(Vector2(20, -268), 12.0, eye)
	ci.draw_circle(Vector2(-24, -268), 5.0, Color.BLACK)
	ci.draw_circle(Vector2(16, -268), 5.0, Color.BLACK)
	ci.draw_line(Vector2(-36, -292), Vector2(-8, -279), Color.BLACK, 6.0)
	ci.draw_line(Vector2(36, -292), Vector2(8, -279), Color.BLACK, 6.0)
	if tele > 0.15:
		ci.draw_circle(Vector2(-4, -236), 14.0 + tele * 10.0, Color("#120808"))
		ci.draw_circle(Vector2(-4, -236), 6.0 + tele * 8.0, Color("#ff7a1f"))
	else:
		ci.draw_line(Vector2(-22, -238), Vector2(14, -238), Color("#120808"), 5.0)


static func heart(ci: CanvasItem, pos: Vector2, s: float, full: bool) -> void:
	var col := Color("#e63946") if full else Color(0.25, 0.2, 0.3, 0.8)
	ci.draw_circle(pos + Vector2(-s * 0.5, -s * 0.25), s * 0.55, col)
	ci.draw_circle(pos + Vector2(s * 0.5, -s * 0.25), s * 0.55, col)
	ci.draw_colored_polygon(PackedVector2Array([
		pos + Vector2(-s * 1.03, -s * 0.05), pos + Vector2(s * 1.03, -s * 0.05), pos + Vector2(0, s * 1.05)]), col)


static func tree(ci: CanvasItem, base: Vector2, h: float, shade: Color) -> void:
	var w := h * 0.12
	ci.draw_rect(Rect2(base.x - w * 0.5, base.y - h * 0.55, w, h * 0.55), Color("#4a3322") * shade)
	var leaf := Color("#1f5a34") * shade
	ci.draw_circle(Vector2(base.x, base.y - h * 0.72), h * 0.26, leaf)
	ci.draw_circle(Vector2(base.x - h * 0.16, base.y - h * 0.6), h * 0.2, leaf.darkened(0.1))
	ci.draw_circle(Vector2(base.x + h * 0.16, base.y - h * 0.6), h * 0.2, leaf.darkened(0.1))
