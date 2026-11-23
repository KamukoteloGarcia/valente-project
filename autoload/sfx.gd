extends Node
## Efeitos sonoros gerados por código (autoload "Sfx"). Não precisa de ficheiros de áudio.
## Uso: Sfx.play("jump")  |  sons: jump, hit, reflect, pick, win, click

const RATE := 22050

var _players: Array[AudioStreamPlayer] = []
var _sounds: Dictionary = {}


func _ready() -> void:
	for i in 6:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_players.append(p)
	_sounds["jump"] = _tone([380.0, 620.0, 760.0], 0.16, false)
	_sounds["hit"] = _tone([260.0, 140.0, 90.0], 0.28, true)
	_sounds["reflect"] = _tone([900.0, 1300.0], 0.14, false)
	_sounds["pick"] = _tone([600.0, 800.0, 1000.0, 1300.0], 0.32, false)
	_sounds["win"] = _tone([520.0, 660.0, 780.0, 1040.0, 1040.0], 0.7, false)
	_sounds["click"] = _tone([520.0, 640.0], 0.07, false)


func play(sound_name: String) -> void:
	if not GameState.sound_on or not _sounds.has(sound_name):
		return
	for p in _players:
		if not p.playing:
			p.stream = _sounds[sound_name]
			p.play()
			return


func _tone(freqs: Array, duration: float, noisy: bool) -> AudioStreamWAV:
	var n := int(RATE * duration)
	var data := PackedByteArray()
	data.resize(n * 2)
	var phase := 0.0
	for i in n:
		var seg := mini(int(float(i) / float(n) * freqs.size()), freqs.size() - 1)
		phase += TAU * float(freqs[seg]) / float(RATE)
		var envelope := 1.0 - float(i) / float(n)
		var s := sin(phase)
		if noisy:
			s = s * 0.6 + randf_range(-0.4, 0.4)
		data.encode_s16(i * 2, int(clampf(s * envelope * 0.4, -1.0, 1.0) * 32767.0))
	var w := AudioStreamWAV.new()
	w.format = AudioStreamWAV.FORMAT_16_BITS
	w.mix_rate = RATE
	w.stereo = false
	w.data = data
	return w
