extends Label

@export var player: Player  # assigne PlayerInstance dans l'inspecteur

func _process(_delta):
	if player == null:
		text = "0/0"
		return

	if player.current_weapon == null:
		text = "0/0"
		return

	text = str(player.current_weapon.ammo_in_mag) + "/" + str(player.current_weapon.max_ammo)
