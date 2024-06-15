extends Area2D

func _physics_process(delta):
	var player_in_range = get_overlapping_bodies()
	if player_in_range.size() > 0:
		var target = player_in_range.front()
