extends Node
class_name SoundPlayer


@export var CurrentlyPlaying:String = "NONE"
var Songs = {}


func _ready():
	for node in self.get_children():
		Songs[node.name] = node


func PauseSong(paused: bool):
	if CurrentlyPlaying == "NONE":
		return
	
	Songs[CurrentlyPlaying].get_tree().paused = paused


func PlaySongWithIntro(intro: String, song: String):
	var introFile = Songs[intro]
	PlaySong(intro)
	
	await introFile.finished
	
	if CurrentlyPlaying != intro:
		return
	
	PlaySong(song)


func StopMusic():
	if CurrentlyPlaying == "NONE": return
	Songs[CurrentlyPlaying].stop()
	CurrentlyPlaying = "NONE"


func PlaySong(song: String):
	if song == "NONE":
		StopMusic()
		return
	
	if not Songs.has(song):
		print("TRYING TO PLAY SOUND THAT DOESNT EXIST: ", song)
		return
		
	print("Switching music from "+CurrentlyPlaying+" to "+song)
	StopMusic()
	
	Songs[song].play()
	CurrentlyPlaying = song


func PlayAtPosition(soundName: String, globalPosition: Vector2) -> AudioStreamPlayer2D:
	if not Songs.has(soundName):
		print("TRYING TO PLAY SOUND THAT DOESNT EXIST: ", soundName)
		return
	
	var newSound = Songs[soundName].duplicate()
	newSound.finished.connect( onSoundFinish.bind(newSound) )
	
	add_child(newSound)
	newSound.global_position = globalPosition
	newSound.play()
	
	return newSound


func PlayOnNode(soundName: String, node: Node):
	if not Songs.has(soundName):
		print("TRYING TO PLAY SOUND THAT DOESNT EXIST: ", soundName)
		return
	
	var newSound = Songs[soundName].duplicate()
	newSound.finished.connect(onSoundFinish, [newSound])
	
	node.add_child(newSound)
	newSound.position = Vector2.ZERO
	newSound.play()


func onSoundFinish(soundNode):
	soundNode.finished.disconnect(onSoundFinish)
	soundNode.queue_free()
