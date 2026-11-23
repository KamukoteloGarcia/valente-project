class_name ValenteFrames
extends RefCounted
## Cria o SpriteFrames do Valente POR CÓDIGO a partir dos PNG em res://assets/valente/frames/.
## Todos os frames têm o mesmo tamanho (304x272) e o mesmo ponto de ancoragem (centro dos pés),
## por isso trocar de animação nunca faz a personagem "saltar" de posição.
##
## Animações: idle, run, jump_rise, jump_apex, jump_fall, land, celebrate, shield_equip, shield_guard

const DIR := "res://assets/valente/frames/"
const FRAME_W := 304
const FRAME_H := 272
const FOOT_Y := 268          # linha dos pés dentro do frame

static var _cache: SpriteFrames = null


static func get_frames() -> SpriteFrames:
	if _cache != null:
		return _cache
	var sf := SpriteFrames.new()
	if sf.has_animation("default"):
		sf.remove_animation("default")
	#            nome            ficheiros                          fps   loop
	_add(sf, "idle",         ["idle"],                           5.0,  true)
	_add(sf, "run",          _seq("run", [0, 1, 2, 3, 4, 5, 6, 7]), 14.0, true)
	_add(sf, "jump_rise",    _seq("jump", [1, 2, 3]),            14.0, false)
	_add(sf, "jump_apex",    _seq("jump", [4, 5]),               8.0,  true)
	_add(sf, "jump_fall",    _seq("jump", [6]),                  5.0,  true)
	_add(sf, "land",         _seq("jump", [7]),                  5.0,  false)
	_add(sf, "celebrate",    _seq("celeb", [0, 1, 2, 3, 4, 5, 6, 7]), 6.0, true)
	_add(sf, "shield_equip", _seq("shield_equip", [0, 1, 2, 3, 4, 5, 6, 7]), 12.0, false)
	_add(sf, "shield_guard", _seq("shield_guard", [0, 1]),       3.0,  true)
	_cache = sf
	return sf


static func _seq(prefix: String, indices: Array) -> Array:
	var names: Array = []
	for i in indices:
		names.append("%s_%d" % [prefix, i])
	return names


static func _add(sf: SpriteFrames, anim: String, files: Array, fps: float, loop: bool) -> void:
	sf.add_animation(anim)
	sf.set_animation_speed(anim, fps)
	sf.set_animation_loop(anim, loop)
	for f in files:
		var tex := load(DIR + str(f) + ".png") as Texture2D
		if tex == null:
			push_error("Sprite em falta: " + DIR + str(f) + ".png")
			continue
		sf.add_frame(anim, tex)


## AnimatedSprite2D pronto a usar, com os pés na origem (0,0) do nó.
static func make_sprite(sprite_scale: float) -> AnimatedSprite2D:
	var s := AnimatedSprite2D.new()
	s.sprite_frames = get_frames()
	s.centered = true
	s.offset = Vector2(0.0, -(FOOT_Y - FRAME_H / 2.0))
	s.scale = Vector2(sprite_scale, sprite_scale)
	s.play("idle")
	return s
