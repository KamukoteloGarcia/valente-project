class_name Level1
extends Node2D
## Nível 1 — Vencer o Medo (A Floresta Escura). Base bíblica: Josué 1:9 e Efésios 6:16.
## Fluxo: Fase 1 (sem escudo) -> apanhar o Escudo da Fé -> Fase 2 -> Arena do Gigante da Sombra.
## Tudo é criado por código: não há cenas nem imagens para configurar.

signal navigate(target: String)

# ===================== AJUSTES (mexam aqui para mudar a dificuldade) =====================
const PLAYER_HP := 5
const MINION_FIRE_INTERVAL := 2.8          # segundos entre chamas de cada Sombra (fase 1)
const MINION_FIRE_INTERVAL_PHASE2 := 2.1   # idem na fase 2 (mais difícil)
const MINION_FIRE_SPEED := 300.0
const MINION_RANGE := 720.0                # a que distância as Sombras começam a atirar
const BOSS_HP := 8
const BOSS_TELEGRAPH := 0.8                # tempo de aviso (boss fica vermelho) antes de atacar
const BOSS_FIRE_SPEED := 340.0
const BOSS_WAVE_SPEED := 300.0

# ===================== MAPA =====================
const GROUND_Y := 600.0                    # tem de ser igual a Valente.GROUND_Y
const ARENA_LEFT := 4400.0
const LEVEL_END := ARENA_LEFT + 1280.0
const SHIELD_X := 2350.0
const PHASE1_MINIONS := [900.0, 1280.0, 1600.0, 1900.0, 2150.0]
const PHASE2_MINIONS := [2750.0, 3000.0, 3250.0, 3500.0, 3800.0, 4050.0]
const HEART_PICKUPS := [1750.0, 3400.0]

var player: Valente
var boss: Boss
var camera: Camera2D
var hud: Hud
var ui: CanvasLayer
var bg: ForestBackground
var shield_btn: TouchScreenButton

var _state := "play"          # play | boss | lost | won
var _trees := PackedVector2Array()
var _progress := 0.0
var _warned := false
var _overlay: Control = null


func _ready() -> void:
	_build_background()
	_scatter_trees()
	_build_player()
	_build_camera()
	_build_ui()
	_spawn_level_objects()
	_build_boss()
	hud.say("Nível 1 — Vencer o Medo\n«Sê forte e corajoso; não temas.» (Josué 1:9)", 5.0)
	hud.say("Salta (PULAR) sobre as chamas e pisa a cabeça das Sombras do Medo!", 4.5)


# ------------------------------------------------------------------ construção

func _build_background() -> void:
	var layer := CanvasLayer.new()
	layer.layer = -10
	add_child(layer)
	bg = ForestBackground.new()
	layer.add_child(bg)


func _scatter_trees() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	var x := 100.0
	while x < LEVEL_END:
		_trees.append(Vector2(x + rng.randf_range(-40.0, 40.0), rng.randf_range(260.0, 420.0)))
		x += 150.0


func _build_player() -> void:
	player = Valente.new()
	player.position = Vector2(180.0, GROUND_Y)
	player.max_hp = PLAYER_HP
	player.hp = PLAYER_HP
	player.min_x = 40.0
	player.max_x = LEVEL_END - 40.0
	player.hurt.connect(_on_player_hurt)
	player.died.connect(_on_player_died)
	add_child(player)


func _build_camera() -> void:
	camera = Camera2D.new()
	camera.limit_left = 0
	camera.limit_right = int(LEVEL_END)
	camera.limit_top = 0
	camera.limit_bottom = 720
	camera.position = Vector2(640.0, 360.0)
	add_child(camera)


func _build_ui() -> void:
	ui = CanvasLayer.new()
	ui.layer = 10
	add_child(ui)
	hud = Hud.new()
	hud.hp = PLAYER_HP
	hud.max_hp = PLAYER_HP
	hud.pause_pressed.connect(_pause)
	ui.add_child(hud)
	_touch_button("mover_esq", Vector2(120.0, 610.0), 70.0, "<")
	_touch_button("mover_dir", Vector2(300.0, 610.0), 70.0, ">")
	_touch_button("pular", Vector2(1160.0, 600.0), 80.0, "PULAR")
	shield_btn = _touch_button("escudo", Vector2(990.0, 620.0), 66.0, "ESCUDO")
	shield_btn.visible = false      # só aparece depois de apanhar o Escudo da Fé


func _touch_button(action: String, center: Vector2, radius: float, text: String) -> TouchScreenButton:
	var b := TouchScreenButton.new()
	b.action = action
	var shape := CircleShape2D.new()
	shape.radius = radius
	b.shape = shape
	b.shape_visible = false
	b.passby_press = true
	b.position = center
	var v := TouchVisual.new()
	v.radius = radius
	v.label = text
	b.add_child(v)
	b.pressed.connect(v.set_held.bind(true))
	b.released.connect(v.set_held.bind(false))
	ui.add_child(b)
	return b


func _spawn_level_objects() -> void:
	for x in PHASE1_MINIONS:
		_spawn_minion(float(x), MINION_FIRE_INTERVAL)
	for x in PHASE2_MINIONS:
		_spawn_minion(float(x), MINION_FIRE_INTERVAL_PHASE2)
	_spawn_pickup("escudo", SHIELD_X)
	for x in HEART_PICKUPS:
		_spawn_pickup("coracao", float(x))


func _spawn_minion(x: float, interval: float) -> void:
	var m := Minion.new()
	m.position = Vector2(x, GROUND_Y)
	m.player = player
	m.fire_interval = interval
	m.fire_speed = MINION_FIRE_SPEED
	m.fire_range = MINION_RANGE
	m.fire_requested.connect(_on_minion_fire)
	add_child(m)


func _spawn_pickup(kind: String, x: float) -> void:
	var p := Pickup.new()
	p.kind = kind
	p.position = Vector2(x, GROUND_Y)
	add_child(p)


func _build_boss() -> void:
	boss = Boss.new()
	boss.position = Vector2(ARENA_LEFT + 1130.0, GROUND_Y)
	boss.player = player
	boss.max_hp = BOSS_HP
	boss.hp = BOSS_HP
	boss.telegraph_time = BOSS_TELEGRAPH
	boss.fire_speed = BOSS_FIRE_SPEED
	boss.wave_speed = BOSS_WAVE_SPEED
	boss.fire_requested.connect(_spawn_projectile)
	boss.summon_requested.connect(_on_boss_summon)
	boss.hp_changed.connect(_on_boss_hp_changed)
	boss.defeated.connect(_on_boss_defeated)
	add_child(boss)


# ------------------------------------------------------------------ desenho do cenário

func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var cam_x := camera.get_screen_center_position().x
	var left := cam_x - 700.0
	var right := cam_x + 700.0
	var shade := Color(0.5, 0.55, 0.7).lerp(Color.WHITE, _progress)
	for tr in _trees:
		if tr.x > left - 200.0 and tr.x < right + 200.0:
			Art.tree(self, Vector2(tr.x, GROUND_Y), tr.y, shade)
	var ground := Color("#1c3320").lerp(Color("#2d5a2c"), _progress)
	draw_rect(Rect2(left, GROUND_Y, right - left, 200.0), ground)
	draw_rect(Rect2(left, GROUND_Y, right - left, 14.0), Color("#3f7d33").lerp(Color("#6bbf4a"), _progress))
	var gx := floorf(left / 60.0) * 60.0
	while gx < right:
		draw_line(Vector2(gx, GROUND_Y + 14.0), Vector2(gx - 6.0, GROUND_Y + 4.0), ground.lightened(0.2), 3.0)
		gx += 60.0


# ------------------------------------------------------------------ lógica principal

func _physics_process(_delta: float) -> void:
	camera.position = Vector2(player.position.x, 360.0)
	_progress = clampf(player.position.x / (ARENA_LEFT + 640.0), 0.0, 1.0)
	bg.cam_x = camera.get_screen_center_position().x - 640.0
	bg.progress = _progress
	bg.queue_redraw()
	if _state != "play" and _state != "boss":
		return

	if _state == "play":
		if not _warned and player.position.x >= ARENA_LEFT + 320.0:
			_warned = true
			hud.say("Algo enorme se aproxima… Sê forte e corajoso!", 3.5, true)
		if player.position.x >= ARENA_LEFT + 640.0:
			_start_boss()

	_check_projectiles()
	_check_minions()
	_check_pickups()
	_check_boss_contact()


func _start_boss() -> void:
	_state = "boss"
	player.min_x = ARENA_LEFT + 40.0        # a arena fecha: já não se pode voltar atrás
	boss.active = true
	hud.boss_visible = true
	hud.boss_hp = boss.hp
	hud.boss_max = boss.max_hp
	hud.say("O Gigante da Sombra: o MEDO em pessoa!\nChamas: bloqueia com o ESCUDO e devolve-as.\nOndas roxas: SALTA!", 6.5, true)


func _check_projectiles() -> void:
	for node in get_tree().get_nodes_in_group("projectiles"):
		var p := node as Projectile
		if p == null:
			continue
		var r := p.rect()
		if p.hostile:
			if p.reflectable and player.shield_up and r.intersects(player.shield_box()):
				p.reflect()
				Sfx.play("reflect")
			elif r.intersects(player.hurt_box()):
				if player.take_damage(1) and p.kind == "fire":
					p.queue_free()
		else:
			if boss.active and r.intersects(boss.hurt_box()):
				boss.hit()
				p.queue_free()
				continue
			for mnode in get_tree().get_nodes_in_group("minions"):
				var m := mnode as Minion
				if m != null and m.alive and r.intersects(m.hurt_box()):
					m.die()
					p.queue_free()
					break


func _check_minions() -> void:
	var hb := player.hurt_box()
	for node in get_tree().get_nodes_in_group("minions"):
		var m := node as Minion
		if m == null or not m.alive:
			continue
		var mb := m.hurt_box()
		if player.shield_up and player.shield_box().intersects(mb):
			m.die()                                   # as Sombras fogem da luz da fé
			Sfx.play("reflect")
		elif hb.intersects(mb):
			if player.is_falling() and player.position.y < m.position.y - 40.0:
				m.die()                               # pisar a cabeça
				player.bounce()
				Sfx.play("pick")
			else:
				player.take_damage(1)


func _check_pickups() -> void:
	for node in get_tree().get_nodes_in_group("pickups"):
		var pk := node as Pickup
		if pk == null or not player.hurt_box().intersects(pk.rect()):
			continue
		if pk.kind == "escudo":
			player.equip_shield()        # toca a animação de pegar no escudo
			shield_btn.visible = true
			Sfx.play("pick")
			hud.say("Escudo da Fé!\nSegura ESCUDO para apagar os dardos inflamados e devolver as chamas. (Efésios 6:16)", 6.0, true)
		elif pk.kind == "coracao":
			if player.hp >= player.max_hp:
				continue
			player.heal()
			Sfx.play("pick")
		pk.remove_from_group("pickups")
		pk.queue_free()


func _check_boss_contact() -> void:
	if boss.active and not boss.dead and player.hurt_box().intersects(boss.hurt_box()):
		player.take_damage(1)


# ------------------------------------------------------------------ eventos

func _spawn_projectile(from: Vector2, vel: Vector2, kind: String) -> void:
	var p := Projectile.new()
	p.position = from
	p.vel = vel
	p.kind = kind
	if kind == "wave":
		p.reflectable = false
		p.position.y = GROUND_Y
	add_child(p)


func _on_minion_fire(from: Vector2, vel: Vector2) -> void:
	_spawn_projectile(from, vel, "fire")


func _on_boss_summon(at: Vector2) -> void:
	_spawn_minion(at.x, MINION_FIRE_INTERVAL_PHASE2)


func _on_boss_hp_changed(current_hp: int, max_hp: int) -> void:
	hud.boss_hp = current_hp
	hud.boss_max = max_hp


func _on_player_hurt(current_hp: int) -> void:
	hud.hp = current_hp


func _on_player_died() -> void:
	if _state == "lost" or _state == "won":
		return
	_state = "lost"
	player.controls_enabled = false
	await get_tree().create_timer(0.9).timeout
	_show_overlay("Não desistas!",
		"«Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus.» (Isaías 41:10)",
		[["Tentar de novo", _retry], ["Menu", _to_menu]], Color("#ff9a7a"))


func _on_boss_defeated() -> void:
	if _state == "won":
		return
	_state = "won"
	player.celebrate()
	hud.boss_visible = false
	_clear_hostiles()
	Sfx.play("win")
	hud.say("O Gigante da Sombra caiu! O medo não tem poder sobre quem confia em Deus.", 4.0, true)
	await get_tree().create_timer(2.8).timeout
	GameState.complete_level(1, "escudo")
	_show_overlay("Venceste o Medo!",
		"«Deus não nos deu espírito de covardia, mas de poder, de amor e de moderação.» (2 Timóteo 1:7)\n\nGanhaste: Escudo da Fé (Efésios 6:16)",
		[["Continuar", _to_levels], ["Jogar de novo", _retry]], UIKit.GOLD)


func _clear_hostiles() -> void:
	for n in get_tree().get_nodes_in_group("projectiles"):
		n.queue_free()
	for n in get_tree().get_nodes_in_group("minions"):
		n.queue_free()


# ------------------------------------------------------------------ pausa e ecrãs finais

func _pause() -> void:
	if (_state != "play" and _state != "boss") or _overlay != null:
		return
	get_tree().paused = true
	_show_overlay("Pausa", "", [["Continuar", _resume], ["Menu", _to_menu]], Color.WHITE)


func _resume() -> void:
	get_tree().paused = false
	if _overlay != null:
		_overlay.queue_free()
		_overlay = null


func _retry() -> void:
	navigate.emit("level_1")


func _to_menu() -> void:
	navigate.emit("menu")


func _to_levels() -> void:
	navigate.emit("level_select")


func _show_overlay(title: String, subtitle: String, buttons: Array, title_color: Color) -> void:
	var root := Control.new()
	root.process_mode = Node.PROCESS_MODE_ALWAYS
	ui.add_child(root)
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var dim := ColorRect.new()
	dim.color = Color(0.03, 0.02, 0.1, 0.72)
	root.add_child(dim)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var center := CenterContainer.new()
	root.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 16)
	center.add_child(box)
	box.add_child(UIKit.label(title, 72, title_color))
	if subtitle != "":
		box.add_child(UIKit.label(subtitle, 28, Color("#ffeec2"), 860.0))
	for b in buttons:
		var btn := UIKit.button(str(b[0]), Vector2(380, 68))
		btn.pressed.connect(b[1])
		box.add_child(btn)
	_overlay = root
