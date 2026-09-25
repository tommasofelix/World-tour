# res://systems/audio_cue_system.gd
class_name AudioCueSystem
extends Node

## Sottosistema di Sound Design, Sintesi Procedurale di Earcons e Riproduzione Audio Cues
## Rispetta i vincoli di volume sicuro (0.70f - 0.75f lineare, -2.5 dB) e ducking automatico (40%).
## Funziona deterministicamente a 0 ms anche in modalità Headless.

signal cue_played(cue_type: int, stream_name: String)
signal volume_changed(new_volume_linear: float, is_ducked: bool)

var base_volume_linear: float = Constants.AUDIO_SAFE_VOLUME_LINEAR
var is_ducked: bool = false
var audio_player: AudioStreamPlayer = null

# Cache dei flussi generati per evitare ricalcoli in tempo reale
var _stream_cache: Dictionary = {}

func _init() -> void:
	name = "AudioCueSystem"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_audio_player()
	precache_all_cues()

## Pre-riscaldamento deterministico della cache audio all'avvio per eliminare ogni hitch durante il gameplay
func precache_all_cues() -> void:
	var all_types: Array[int] = [
		Enums.AudioCueType.AREA_PERSONAL,
		Enums.AudioCueType.AREA_CREATION,
		Enums.AudioCueType.AREA_CAREER,
		Enums.AudioCueType.AREA_UPGRADES,
		Enums.AudioCueType.CERTIFICATION_AWARD,
		Enums.AudioCueType.CHART_NUMBER_ONE,
		Enums.AudioCueType.STADIUM_SOLD_OUT,
		Enums.AudioCueType.NIGHT_OVERTIME_BELL,
		Enums.AudioCueType.HIGH_SIGNAL_ALERT,
		Enums.AudioCueType.COLLISION_BUMP,
		Enums.AudioCueType.HOTSPOT_PROXIMITY
	]
	for t in all_types:
		get_or_generate_cue_stream(t)

func _setup_audio_player() -> void:
	if not audio_player:
		audio_player = AudioStreamPlayer.new()
		audio_player.name = "CuePlayer"
		add_child(audio_player)
	_update_player_volume()

## Calcola il volume lineare effettivo tenendo conto del ducking e dei vincoli salvavita
func get_effective_volume_linear() -> float:
	var safe_base: float = clampf(base_volume_linear, 0.0, Constants.AUDIO_SAFE_VOLUME_LINEAR)
	if is_ducked:
		return clampf(safe_base * Constants.AUDIO_DUCKING_RATIO, 0.0, Constants.AUDIO_SAFE_VOLUME_LINEAR)
	return safe_base

## Aggiorna il volume del player audio convertendo da lineare a decibel
func _update_player_volume() -> void:
	if not audio_player:
		return
	var eff_lin: float = get_effective_volume_linear()
	if eff_lin <= 0.0001:
		audio_player.volume_db = -80.0
	else:
		audio_player.volume_db = linear_to_db(eff_lin)
	volume_changed.emit(eff_lin, is_ducked)

## Imposta il volume base (bloccato al massimo di sicurezza 0.75f)
func set_base_volume(vol_linear: float) -> void:
	base_volume_linear = clampf(vol_linear, 0.0, Constants.AUDIO_SAFE_VOLUME_LINEAR)
	_update_player_volume()

## Attiva o disattiva il ducking acustico (usato durante la sintesi vocale di NVDA)
func set_ducking(enabled: bool) -> void:
	if is_ducked == enabled:
		return
	is_ducked = enabled
	_update_player_volume()

## Riproduce un feedback sonoro (Earcon / Audio Cue) in base al tipo
func play_cue(cue_type: int) -> bool:
	if cue_type == Enums.AudioCueType.NONE:
		return false
		
	var stream: AudioStreamWAV = get_or_generate_cue_stream(cue_type)
	if not stream:
		return false
		
	if audio_player:
		audio_player.stop()
		audio_player.stream = stream
		_update_player_volume()
		if DisplayServer.get_name() != "headless":
			audio_player.play()
		
	cue_played.emit(cue_type, Enums.get_audio_cue_name(cue_type))
	return true

## Interrompe la riproduzione in corso e rilascia esplicitamente lo stream per prevenire memory leak
func stop() -> void:
	if audio_player:
		audio_player.stop()
		audio_player.stream = null

func _exit_tree() -> void:
	stop()
	_stream_cache.clear()

## Restituisce o genera proceduralmente lo stream sintetizzato in memoria
func get_or_generate_cue_stream(cue_type: int) -> AudioStreamWAV:
	if _stream_cache.has(cue_type):
		return _stream_cache[cue_type]
		
	var stream: AudioStreamWAV = null
	match cue_type:
		Enums.AudioCueType.AREA_PERSONAL:
			stream = _generate_acoustic_chord_cue()
		Enums.AudioCueType.AREA_CREATION:
			stream = _generate_studio_synth_cue()
		Enums.AudioCueType.AREA_CAREER:
			stream = _generate_rock_power_chord_cue()
		Enums.AudioCueType.AREA_UPGRADES:
			stream = _generate_metallic_upgrade_cue()
		Enums.AudioCueType.CERTIFICATION_AWARD:
			stream = _generate_fanfare_cue()
		Enums.AudioCueType.CHART_NUMBER_ONE:
			stream = _generate_victory_chime_cue()
		Enums.AudioCueType.STADIUM_SOLD_OUT:
			stream = _generate_stadium_crowd_cue()
		Enums.AudioCueType.NIGHT_OVERTIME_BELL:
			stream = _generate_night_bell_cue()
		Enums.AudioCueType.HIGH_SIGNAL_ALERT:
			stream = _generate_high_alert_cue()
		Enums.AudioCueType.COLLISION_BUMP:
			stream = _generate_collision_bump_cue()
		Enums.AudioCueType.HOTSPOT_PROXIMITY:
			stream = _generate_hotspot_proximity_cue()
		_:
			stream = _generate_simple_tone(440.0, 0.2)
			
	if stream:
		_stream_cache[cue_type] = stream
	return stream

# -------------------------------------------------------------------------
# GENERATORI PROCEDURALI DI FORME D'ONDA (16-bit PCM Mono in memoria)
# -------------------------------------------------------------------------

func _create_wav(total_samples: int) -> AudioStreamWAV:
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = Constants.AUDIO_SAFE_SAMPLE_RATE
	wav.stereo = false
	return wav

## Generatore base di tono sinusoidale con inviluppo esponenziale
func _generate_simple_tone(frequency: float, duration: float) -> AudioStreamWAV:
	var sample_rate: int = Constants.AUDIO_SAFE_SAMPLE_RATE
	var total_samples: int = int(round(duration * float(sample_rate)))
	var wav: AudioStreamWAV = _create_wav(total_samples)
	var byte_data := PackedByteArray()
	byte_data.resize(total_samples * 2)
	
	for i in range(total_samples):
		var t: float = float(i) / float(sample_rate)
		var envelope: float = exp(-4.0 * t / duration)
		var s: float = sin(TAU * frequency * t) * envelope * 0.7
		var s_int: int = clampi(int(round(s * 32767.0)), -32768, 32767)
		byte_data.encode_s16(i * 2, s_int)
		
	wav.data = byte_data
	return wav

## Area 1: Hub Personale — Arpeggio caldo chitarra acustica (C4 - E4 - G4)
func _generate_acoustic_chord_cue() -> AudioStreamWAV:
	var sample_rate: int = Constants.AUDIO_SAFE_SAMPLE_RATE
	var duration: float = Constants.AUDIO_CUE_DEFAULT_DURATION
	var total_samples: int = int(round(duration * float(sample_rate)))
	var wav: AudioStreamWAV = _create_wav(total_samples)
	var byte_data := PackedByteArray()
	byte_data.resize(total_samples * 2)
	
	var freqs: Array[float] = [261.63, 329.63, 392.0] # Do4, Mi4, Sol4
	for i in range(total_samples):
		var t: float = float(i) / float(sample_rate)
		var s: float = 0.0
		for idx in range(freqs.size()):
			var note_offset: float = float(idx) * 0.04
			if t >= note_offset:
				var note_t: float = t - note_offset
				var env: float = exp(-6.0 * note_t / duration)
				# Fondamentale + 2a armonica per calore acustico
				s += (sin(TAU * freqs[idx] * note_t) * 0.7 + sin(TAU * freqs[idx] * 2.0 * note_t) * 0.3) * env
		s = (s / 3.0) * 0.75
		var s_int: int = clampi(int(round(s * 32767.0)), -32768, 32767)
		byte_data.encode_s16(i * 2, s_int)
		
	wav.data = byte_data
	return wav

## Area 2: Creazione & Produzione — Impulso synth / sequencer ritmico da studio
func _generate_studio_synth_cue() -> AudioStreamWAV:
	var sample_rate: int = Constants.AUDIO_SAFE_SAMPLE_RATE
	var duration: float = Constants.AUDIO_CUE_DEFAULT_DURATION
	var total_samples: int = int(round(duration * float(sample_rate)))
	var wav: AudioStreamWAV = _create_wav(total_samples)
	var byte_data := PackedByteArray()
	byte_data.resize(total_samples * 2)
	
	for i in range(total_samples):
		var t: float = float(i) / float(sample_rate)
		var progress: float = t / duration
		var freq: float = lerpf(350.0, 700.0, progress)
		var env: float = exp(-5.0 * progress)
		# Forma d'onda triangolare morbida da synth
		var phase: float = fmod(TAU * freq * t, TAU)
		var tri: float = 2.0 * abs((phase / PI) - 1.0) - 1.0
		var s: float = tri * env * 0.7
		var s_int: int = clampi(int(round(s * 32767.0)), -32768, 32767)
		byte_data.encode_s16(i * 2, s_int)
		
	wav.data = byte_data
	return wav

## Area 3: Carriera & Band — Power chord distorto rock
func _generate_rock_power_chord_cue() -> AudioStreamWAV:
	var sample_rate: int = Constants.AUDIO_SAFE_SAMPLE_RATE
	var duration: float = Constants.AUDIO_CUE_DEFAULT_DURATION
	var total_samples: int = int(round(duration * float(sample_rate)))
	var wav: AudioStreamWAV = _create_wav(total_samples)
	var byte_data := PackedByteArray()
	byte_data.resize(total_samples * 2)
	
	# E power chord: E2 (82.4 Hz), B2 (123.5 Hz), E3 (164.8 Hz)
	for i in range(total_samples):
		var t: float = float(i) / float(sample_rate)
		var env: float = exp(-4.5 * t / duration)
		var clean: float = (sin(TAU * 82.4 * t) + sin(TAU * 123.5 * t) + sin(TAU * 164.8 * t)) / 3.0
		# Saturazione armonica non-lineare per emulare overdrive valvolare
		var drive: float = clean * 2.5
		var distorted: float = tanh(drive) * 0.75 * env
		var s_int: int = clampi(int(round(distorted * 32767.0)), -32768, 32767)
		byte_data.encode_s16(i * 2, s_int)
		
	wav.data = byte_data
	return wav

## Area 4: Skills & Upgrades — Tocco metallico incudine / tintinnio attrezzi
func _generate_metallic_upgrade_cue() -> AudioStreamWAV:
	var sample_rate: int = Constants.AUDIO_SAFE_SAMPLE_RATE
	var duration: float = Constants.AUDIO_CUE_DEFAULT_DURATION
	var total_samples: int = int(round(duration * float(sample_rate)))
	var wav: AudioStreamWAV = _create_wav(total_samples)
	var byte_data := PackedByteArray()
	byte_data.resize(total_samples * 2)
	
	for i in range(total_samples):
		var t: float = float(i) / float(sample_rate)
		var env1: float = exp(-12.0 * t / duration)
		var env2: float = exp(-6.0 * t / duration)
		var metal: float = (sin(TAU * 1200.0 * t) * 0.6 * env1) + (sin(TAU * 2400.0 * t) * 0.4 * env2)
		var s_int: int = clampi(int(round(metal * 0.7 * 32767.0)), -32768, 32767)
		byte_data.encode_s16(i * 2, s_int)
		
	wav.data = byte_data
	return wav

## Evento: Fanfara Trionfale Certificazioni (Oro, Platino, Diamante)
func _generate_fanfare_cue() -> AudioStreamWAV:
	var sample_rate: int = Constants.AUDIO_SAFE_SAMPLE_RATE
	var duration: float = Constants.AUDIO_CUE_CELEBRATION_DURATION
	var total_samples: int = int(round(duration * float(sample_rate)))
	var wav: AudioStreamWAV = _create_wav(total_samples)
	var byte_data := PackedByteArray()
	byte_data.resize(total_samples * 2)
	
	var notes: Array[float] = [523.25, 659.25, 783.99, 1046.5] # C5, E5, G5, C6
	for i in range(total_samples):
		var t: float = float(i) / float(sample_rate)
		var s: float = 0.0
		for n_idx in range(notes.size()):
			var start_t: float = float(n_idx) * 0.12
			if t >= start_t:
				var local_t: float = t - start_t
				var env: float = exp(-3.0 * local_t / (duration - start_t))
				s += sin(TAU * notes[n_idx] * local_t) * env * 0.35
		var s_int: int = clampi(int(round(s * 0.75 * 32767.0)), -32768, 32767)
		byte_data.encode_s16(i * 2, s_int)
		
	wav.data = byte_data
	return wav

## Evento: #1 in Classifica — Rintocco celebrativo maestoso
func _generate_victory_chime_cue() -> AudioStreamWAV:
	var sample_rate: int = Constants.AUDIO_SAFE_SAMPLE_RATE
	var duration: float = 0.75
	var total_samples: int = int(round(duration * float(sample_rate)))
	var wav: AudioStreamWAV = _create_wav(total_samples)
	var byte_data := PackedByteArray()
	byte_data.resize(total_samples * 2)
	
	for i in range(total_samples):
		var t: float = float(i) / float(sample_rate)
		var env: float = exp(-4.0 * t / duration)
		# Accordo brillante maggiore Do6 (1046.5 Hz) + Mi6 (1318.5 Hz) + Sol6 (1567.98 Hz)
		var chime: float = (sin(TAU * 1046.5 * t) + sin(TAU * 1318.5 * t) * 0.8 + sin(TAU * 1567.98 * t) * 0.6) / 2.4
		var s_int: int = clampi(int(round(chime * env * 0.75 * 32767.0)), -32768, 32767)
		byte_data.encode_s16(i * 2, s_int)
		
	wav.data = byte_data
	return wav

## Evento: Sold Out Stadio — Boato folla e sub-impact
func _generate_stadium_crowd_cue() -> AudioStreamWAV:
	var sample_rate: int = Constants.AUDIO_SAFE_SAMPLE_RATE
	var duration: float = 0.85
	var total_samples: int = int(round(duration * float(sample_rate)))
	var wav: AudioStreamWAV = _create_wav(total_samples)
	var byte_data := PackedByteArray()
	byte_data.resize(total_samples * 2)
	
	# Generazione pseudo-rumore filtrato + sub-bass
	var noise_state: int = 12345
	for i in range(total_samples):
		var t: float = float(i) / float(sample_rate)
		var env: float = sin(PI * t / duration) # Crescendo e decrescendo fluido
		# LCG pseudo-random per rumore bianco uniforme
		noise_state = (noise_state * 1103515245 + 12345) & 0x7FFFFFFF
		var white_noise: float = (float(noise_state) / 1073741824.0) - 1.0
		# Sub-bass a 60 Hz per l'impatto tellurico dello stadio
		var sub_bass: float = sin(TAU * 60.0 * t) * exp(-4.0 * t / duration)
		var crowd: float = (white_noise * 0.4 + sub_bass * 0.6) * env * 0.7
		var s_int: int = clampi(int(round(crowd * 32767.0)), -32768, 32767)
		byte_data.encode_s16(i * 2, s_int)
		
	wav.data = byte_data
	return wav

## Evento: Overtime Notturno — Campana notturna
func _generate_night_bell_cue() -> AudioStreamWAV:
	var sample_rate: int = Constants.AUDIO_SAFE_SAMPLE_RATE
	var duration: float = 0.60
	var total_samples: int = int(round(duration * float(sample_rate)))
	var wav: AudioStreamWAV = _create_wav(total_samples)
	var byte_data := PackedByteArray()
	byte_data.resize(total_samples * 2)
	
	for i in range(total_samples):
		var t: float = float(i) / float(sample_rate)
		var env: float = exp(-5.0 * t / duration)
		var bell: float = (sin(TAU * 180.0 * t) + sin(TAU * 360.0 * t) * 0.5 + sin(TAU * 540.0 * t) * 0.25) / 1.75
		var s_int: int = clampi(int(round(bell * env * 0.75 * 32767.0)), -32768, 32767)
		byte_data.encode_s16(i * 2, s_int)
		
	wav.data = byte_data
	return wav

## Evento: Allarme ad Alto Segnale — Segnale acuto penetrativo
func _generate_high_alert_cue() -> AudioStreamWAV:
	var sample_rate: int = Constants.AUDIO_SAFE_SAMPLE_RATE
	var duration: float = 0.40
	var total_samples: int = int(round(duration * float(sample_rate)))
	var wav: AudioStreamWAV = _create_wav(total_samples)
	var byte_data := PackedByteArray()
	byte_data.resize(total_samples * 2)
	
	for i in range(total_samples):
		var t: float = float(i) / float(sample_rate)
		var pulse: int = int(t * 15.0) % 2
		var freq: float = 1760.0 if pulse == 0 else 2200.0
		var env: float = exp(-3.0 * t / duration)
		var s: float = sin(TAU * freq * t) * env * 0.7
		var s_int: int = clampi(int(round(s * 32767.0)), -32768, 32767)
		byte_data.encode_s16(i * 2, s_int)
		
	wav.data = byte_data
	return wav

## Evento: Urto contro Ostacolo — Breve thud smorzato a bassa frequenza
func _generate_collision_bump_cue() -> AudioStreamWAV:
	var sample_rate: int = Constants.AUDIO_SAFE_SAMPLE_RATE
	var duration: float = 0.08
	var total_samples: int = int(round(duration * float(sample_rate)))
	var wav: AudioStreamWAV = _create_wav(total_samples)
	var byte_data := PackedByteArray()
	byte_data.resize(total_samples * 2)
	
	for i in range(total_samples):
		var t: float = float(i) / float(sample_rate)
		var freq: float = 75.0 - (35.0 * (t / duration))
		var env: float = exp(-12.0 * t / duration)
		var s: float = sin(TAU * freq * t) * env * 0.55
		var s_int: int = clampi(int(round(s * 32767.0)), -32768, 32767)
		byte_data.encode_s16(i * 2, s_int)
		
	wav.data = byte_data
	return wav

## Evento: Rilevamento Arredo Vicino — Delicato chime acuto a due toni armonici
func _generate_hotspot_proximity_cue() -> AudioStreamWAV:
	var sample_rate: int = Constants.AUDIO_SAFE_SAMPLE_RATE
	var duration: float = 0.12
	var total_samples: int = int(round(duration * float(sample_rate)))
	var wav: AudioStreamWAV = _create_wav(total_samples)
	var byte_data := PackedByteArray()
	byte_data.resize(total_samples * 2)
	
	for i in range(total_samples):
		var t: float = float(i) / float(sample_rate)
		var env: float = exp(-9.0 * t / duration)
		var chime: float = (sin(TAU * 880.0 * t) + sin(TAU * 1320.0 * t) * 0.5) / 1.5
		var s_int: int = clampi(int(round(chime * env * 0.45 * 32767.0)), -32768, 32767)
		byte_data.encode_s16(i * 2, s_int)
		
	wav.data = byte_data
	return wav
