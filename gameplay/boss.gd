class_name Boss
extends Node2D
## Gigante da Sombra (boss do Nível 1). Habilidade especial: a ONDA DE MEDO.
## Ciclo: parado -> aviso (fica vermelho) -> ataque -> parado. Quanto menos vida, mais depressa ataca.

signal fire_requested(from: Vector2, vel: Vector2, kind: String)
signal summon_requested(at: Vector2)
signal hp_changed(current_hp: int, max_hp: int)
signal defeated

const PATTERN_A := ["fogo", "onda", "fogo", "fogo", "onda"]
const PATTERN_B := ["fogo", "onda", "invocar", "fogo", "onda"]    # na 2.ª metade da vida

var player: Valente
var max_hp := 8
var hp := 8
var active := false
var dead := false
var telegraph_time := 0.8
var fire_speed := 340.0
var wave_speed := 300.0

var _state := "idle"
var _timer := 1.8
var _pending := ""
var _burst_left := 0
var _idx := -1
var _fire_low := true
var _tele := 0.0
var _t := 0.0
var _hurt_flash := 0.0
var _dead_t := 0.0


func _process(delta: float) -> void:
	_t += delta
	_hurt_flash = maxf(0.0, _hurt_flash - delta * 3.0)
	if dead:
		_dead_t += delta
		position.y += 50.0 * delta
		modulate.a = clampf(1.0 - _dead_t / 2.0, 0.0, 1.0)
	elif active:
		_run_ai(delta)
	queue_redraw()


func _run_ai(delta: float) -> void:
	_timer -= delta
	if _state == "idle":
		if _timer <= 0.0:
			_pending = _next_attack()
			_state = "telegraph"
			_timer = telegraph_time
	elif _state == "telegraph":
		_tele = 1.0 - clampf(_timer / telegraph_time, 0.0, 1.0)
		if _timer <= 0.0:
			_tele = 0.0
			_execute(_pending)
	elif _state == "firing":
		if _timer <= 0.0:
			if _burst_left > 0:
				_burst_left -= 1
				_shoot_fire()
				_timer = 0.7
			else:
				_rest()


func _next_attack() -> String:
	_idx += 1
	var pattern: Array = PATTERN_B if hp <= max_hp / 2 else PATTERN_A
	return str(pattern[_idx % pattern.size()])


func _execute(attack: String) -> void:
	if attack == "fogo":
		_burst_left = 2 if hp <= max_hp / 2 else 1
		_state = "firing"
		_timer = 0.0
	elif attack == "onda":
		fire_requested.emit(position + Vector2(-90.0, 0.0), Vector2(-wave_speed, 0.0), "wave")
		_rest()
	else:
		summon_requested.emit(position + Vector2(-300.0, 0.0))
		_rest()


func _shoot_fire() -> void:
	var h := 40.0 if _fire_low else 85.0
	_fire_low = not _fire_low
	fire_requested.emit(position + Vector2(-125.0, -h), Vector2(-fire_speed, 0.0), "fire")


## Descanso entre ataques: encurta à medida que o boss perde vida (dificuldade crescente).
func _rest() -> void:
	_state = "idle"
	_timer = maxf(1.1, 2.3 - float(max_hp - hp) * 0.15)


func _draw() -> void:
	Art.boss(self, _t, _tele, _hurt_flash)


func hurt_box() -> Rect2:
	return Rect2(position.x - 85.0, position.y - 310.0, 170.0, 310.0)


func hit() -> void:
	if dead:
		return
	hp -= 1
	_hurt_flash = 1.0
	Sfx.play("hit")
	hp_changed.emit(hp, max_hp)
	if hp <= 0:
		dead = true
		active = false
		defeated.emit()
