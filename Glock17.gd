extends Node3D
class_name Weapon

@export var damage: int = 10
@export var range: float = 50.0
@export var max_ammo: int = 17
@export var ammo_in_mag: int = 17
@export var reserve_ammo: int = 34

func shoot():
	if ammo_in_mag > 0:
		ammo_in_mag -= 1
		print("Bang! Munitions restantes :", ammo_in_mag)
	else:
		print("⚠️ Plus de munitions, recharge !")

func reload():
	var needed = max_ammo - ammo_in_mag
	if reserve_ammo > 0 and needed > 0:
		var to_load = min(needed, reserve_ammo)
		ammo_in_mag += to_load
		reserve_ammo -= to_load
		print("🔄 Rechargé :", ammo_in_mag, "/", reserve_ammo)
