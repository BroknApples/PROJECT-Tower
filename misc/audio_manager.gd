extends Node
##
## Audio Manager
##
## Class for playing sounds
##


enum AudioType {
	UI,
	WEAPON,
	ENEMY,
	CURRENCY,
	TOTAL_AUDIO_TYPE_COUNT
}

const UI_CLICK1 = "ui_click1"

## Used to set volume of specific types of sounds
var channels: Array[Array]


func _init() -> void:
	# Setup Array
	for i in range(AudioType.TOTAL_AUDIO_TYPE_COUNT):
		channels.append([])


func _ready() -> void:
	# Setup streams that will always exist
	addStream(UI_CLICK1, AudioType.UI)
	setStreamAudio(UI_CLICK1, load("res://assets/sounds/ui_1.mp3"))


## Get an audio stream
## target_stream_name: Name tag attached to target stream
func getStream(target_stream_name: String) -> AudioStreamPlayer:
	for audio_stream_player in self.get_children():
		if (audio_stream_player.name == target_stream_name):
			return audio_stream_player
	
	return null


## Add new audio stream to the audio manager
## Handle max stream count reached
## stream_name: Name tag of the stream to identify it
## audio_genre: Which type of audio is it -- used to set audio levels in the settings
func addStream(new_stream_name: String, audio_stream_type: AudioType) -> void:
	# Check if stream already exists
	if (getStream(new_stream_name) != null):
		return
	
	var new_stream = AudioStreamPlayer.new()
	new_stream.name = new_stream_name
	
	# TODO: Do with settings menu at some point
	if (audio_stream_type == AudioType.UI):
		pass
	elif (audio_stream_type == AudioType.CURRENCY):
		new_stream.volume_db -= 10
	else:
		new_stream.volume_db -= 35
	
	channels[audio_stream_type].push_back(new_stream)
	self.add_child(new_stream)


## Set sound to play on a stream channel
func setStreamAudio(target_stream_name: String, audio: AudioStream) -> void:
	var channel = getStream(target_stream_name)
	if (channel != null):
		channel.stream = audio


## Play a stream sound
## target_stream_name: Name tag of stream to be played
func playStream(target_stream_name: String) -> void:
	var channel = getStream(target_stream_name)
	if (channel != null):
		channel.play()


## Remove stream player from audio manager
## target_stream_name: Name tag of the stream player to be removed
func removeStream(target_stream_name: String) -> void:
	var channel = getStream(target_stream_name)
	if (channel != null):
		self.remove_child(channel)
