extends AudioStreamPlayer2D

@export var audio_stream_player_2d: AudioStreamPlayer2D

# A list of all existing music tracks
const MUSIC_TRACKS: Array[AudioStream] = [
	preload("res://assets/Musics/1 - Adventure Begin.ogg"),
	preload("res://assets/Musics/2 - The Cave.ogg"),
	preload("res://assets/Musics/3 - Revelation.ogg"),
	preload("res://assets/Musics/4 - Village.ogg"),
	preload("res://assets/Musics/5 - Peaceful.ogg"),
	preload("res://assets/Musics/6 - Story (Short).ogg"),
	preload("res://assets/Musics/6 - Story.ogg"),
	preload("res://assets/Musics/7 - Sad Theme.ogg"),
	preload("res://assets/Musics/8 - End Theme.ogg"),
	preload("res://assets/Musics/9 - Quiet.ogg"),
	preload("res://assets/Musics/10 - Dark Castle.ogg"),
	preload("res://assets/Musics/11 - Clearing.ogg"),
	preload("res://assets/Musics/12 - Temple.ogg"),
	preload("res://assets/Musics/13 - Mystical.ogg"),
	preload("res://assets/Musics/14 - Curse.ogg"),
	preload("res://assets/Musics/15 - Credit Theme.ogg"),
	preload("res://assets/Musics/16 - Melancholia.ogg"),
	preload("res://assets/Musics/17 - Fight.ogg"),
	preload("res://assets/Musics/18 - Aquatic.ogg"),
	preload("res://assets/Musics/19 - Ascension.ogg"),
	preload("res://assets/Musics/20 - Good Time.ogg"),
	preload("res://assets/Musics/21 - Dungeon.ogg"),
	preload("res://assets/Musics/22 - Dream.ogg"),
	preload("res://assets/Musics/23 - Road.ogg"),
	preload("res://assets/Musics/24 - Final Area.ogg"),
	preload("res://assets/Musics/25 - End Theme 2.ogg"),
	preload("res://assets/Musics/26 - Lost Village.ogg"),
	preload("res://assets/Musics/27 - Chill.ogg"),
	preload("res://assets/Musics/28 - Tension.ogg"),
	preload("res://assets/Musics/29 - Lament.ogg"),
	preload("res://assets/Musics/30 - Ruins.ogg"),
	preload("res://assets/Musics/31 - Sunny.ogg"),
	preload("res://assets/Musics/32 - Manor.ogg")
]

# This variables works like a marker for the track
var current_track_number: int = 0


func _ready() -> void:
	play_track(current_track_number)

func _process(delta: float) -> void:
	check_input()


func previous_track():
	if current_track_number - 1 < 0:
		current_track_number = MUSIC_TRACKS.size() - 1
	else:
		current_track_number -=  1
		
	play_track(current_track_number)



func next_track():
	# prevents playing tracks that don't exist, and loops to first song if needed
	if current_track_number + 1 > MUSIC_TRACKS.size() -1:
		current_track_number = 0
	else:
		current_track_number += 1
		
	play_track(current_track_number)
	
	
# resets the stream and loads up next track
func play_track(track_number: int):
	var track: AudioStream = MUSIC_TRACKS[track_number]
	audio_stream_player_2d.stop()
	audio_stream_player_2d.stream = track
	audio_stream_player_2d.play()


# allows player to change songs with , and . keys
func check_input():
	if Input.is_action_just_pressed("next_track"):
		next_track()
	if Input.is_action_just_pressed("previous_track"):
		previous_track()
		


# defaults to playing the next track
func _on_finished() -> void:
	next_track()
