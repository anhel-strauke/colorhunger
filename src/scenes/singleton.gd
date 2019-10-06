extends Node

var next_scene: String
var level = 1

func transit_to_scene(scene_res):
	next_scene = scene_res
	get_tree().change_scene("res://scenes/ui/TransitionScene.tscn")