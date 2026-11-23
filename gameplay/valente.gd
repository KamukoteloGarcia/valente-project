class_name Valente
extends Node2D
## O herói. A origem (0,0) fica nos PÉS. Os desenhos vêm dos sprites (ver valente_frames.gd).
## A física é feita à mão (sem CharacterBody2D) para ser fácil de perceber e ajustar.

signal hurt(current_hp: int)
signal died

const SPEED := 340.0
const JUMP_FORCE := -860.0      # mais negativo = salta mais alto
const GRAVITY := 2300.0
const GROUND_Y := 600.0         # altura do chão (igual em todos os níveis)
const INVULN_TIME := 1.1        # segundos sem levar dano depois de ser atingido
const SPRITE_SCALE := 0.55      # tamanho do sprite no jogo (a personagem fica com ~130 px de altura)
const EQUIP_TIME := 0.8         # duração da animação de pegar no escudo

var max_hp: int = 5
var hp: int = 5
var vel := Vector2.ZERO
var facing := 1.0
var has_shield := false
var shield_up := false
var controls_enabled := true
var min_x := 0.0
var max_x := 5000.0

var _sprite: AnimatedSprite2D
var _invuln := 0.0
var _equip_lock := 0.0
var _land_t := 0.0
var _t := 0.0
var _moving := false
var _on_ground := true
var _celebrating := false
var _dead := false


func _ready() -> void:
	_sprite = ValenteFrames.make_sprite(SPRITE_SCALE)
	add_child(_sprite)


func _physics_process(delta: float) -> void:
	_t += delta
	var dir := 0.0
	var was_on_ground := _on_ground
	_equip_lock = maxf(0.0, _equip_lock - delta)
	var can_act := controls_enabled and _equip_lock <= 0.0 and not _dead
	if can_act:
		dir = Input.get_axis("mover_esq", "mover_dir")
		shield_up = has_shield and Input.is_action_pressed("escudo")
		if Input.is_action_just_pressed("pular") and was_on_ground:
			vel.y = JUMP_FORCE
			Sfx.play("jump")
	else:
		shield_up = false

	vel.x = dir * SPEED * (0.5 if shield_up else 1.0)
	if dir != 0.0 and not shield_up:
		facing = signf(dir)

	vel.y += GRAVITY * delta
	position += vel * delta
	position.x = clampf(position.x, min_x, max_x)
	if position.y >= GROUND_Y:
		position.y = GROUND_Y
		vel.y = 0.0
		_on_ground = true
		if not was_on_ground:
			_land_t = 0.12
	else:
		_on_ground = false

	_moving = absf(dir) > 0.0 and _on_ground
	_land_t = maxf(0.0, _land_t - delta)
	_invuln = maxf(0.0, _invuln - delta)
	modulate.a = 0.4 if (_invuln > 0.0 and int(_invuln * 12.0) % 2 == 0) else 1.0
	_update_animation()


## Escolhe a animação certa para o estado atual (por ordem de prioridade).
func _update_animation() -> void:
	_sprite.flip_h = facing < 0.0
	if _dead:
		return
	var want := "idle"
	if _celebrating:
		want = "celebrate"
	elif _equip_lock > 0.0:
		want = "shield_equip"
	elif shield_up:
		want = "shield_guard"
	elif not _on_ground:
		if vel.y < -300.0:
			want = "jump_rise"
		elif vel.y > 120.0:
			want = "jump_fall"
		else:
			want = "jump_apex"
	elif _land_t > 0.0:
		want = "land"
	elif _moving:
		want = "run"
	if _sprite.animation != want:
		_sprite.play(want)
	var breathe := 1.0 + 0.012 * sin(_t * 3.0) if want == "idle" else 1.0
	_sprite.scale = Vector2(SPRITE_SCALE, SPRITE_SCALE * breathe)


func hurt_box() -> Rect2:
	return Rect2(position.x - 22.0, position.y - 118.0, 44.0, 118.0)


## Área protegida pelo escudo (à frente do Valente, onde o escudo aparece no sprite).
func shield_box() -> Rect2:
	var x := position.x + 16.0 if facing > 0.0 else position.x - 84.0
	return Rect2(x, position.y - 100.0, 68.0, 80.0)


func is_falling() -> bool:
	return vel.y > 0.0 and not _on_ground


func bounce() -> void:
	vel.y = -560.0


func heal() -> void:
	hp = mini(hp + 1, max_hp)
	hurt.emit(hp)


## Chamar ao apanhar o Escudo da Fé: toca a animação de pegar no escudo.
func equip_shield() -> void:
	has_shield = true
	_equip_lock = EQUIP_TIME
	vel.x = 0.0


## Chamar quando o nível acaba: o Valente celebra.
func celebrate() -> void:
	_celebrating = true
	controls_enabled = false


## Devolve true se o dano foi mesmo aplicado.
func take_damage(amount: int) -> bool:
	if _invuln > 0.0 or hp <= 0 or _equip_lock > 0.0 or _celebrating:
		return false
	hp = maxi(0, hp - amount)
	_invuln = INVULN_TIME
	vel.y = -320.0
	Sfx.play("hit")
	hurt.emit(hp)
	if hp <= 0:
		_dead = true
		_sprite.play("jump_fall")
		var tw := create_tween()
		tw.tween_property(_sprite, "rotation_degrees", -75.0 * facing, 0.4)
		died.emit()
	return true
