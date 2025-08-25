extends Control




# Déclaration de variables pour la connection et le comptage de joueurs

var pPosition : Array  #array contenant les différents "slots" que peuvent occuper les joueurs visuellement dans le lobby.
var state = "main"     #Main c'est qu'on est dans le menu principal, play c'est le menu de connection, settings c'est les options.
var multiplayerMaster

func _ready():
	
	multiplayerMaster = get_node("/root/GameMaster/MultiplayerMaster")
	%PlayMenu.visible = false
	$LobbyMenu.visible = false
	pPosition =  [$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer/PlayerContainer1,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer/PlayerContainer2,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer/PlayerContainer3,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer/PlayerContainer4,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer2/PlayerContainer5,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer2/PlayerContainer6,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer2/PlayerContainer7,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer2/PlayerContainer8]
	

func _process(delta: float) -> void:
	pass

# FONCTIONS DE CONNECTION AUTOMATIQUES :
#this gets called on the server and clients when client connects


## LES BOUTONS DU MENU :


func _on_button_quit_pressed() -> void:
	get_tree().quit()  

func _on_button_play_pressed() -> void:
	state = "play"
	%PlayMenu.visible =true
	%MainMenu.visible =false
	pass

func _on_button_host_pressed() -> void:
	multiplayerMaster.Host()
	$LobbyMenu.visible = true
	%PlayMenu.visible = false
	$LobbyMenu/HBoxContainer/Panel2/Play_Ready.text = "Play"
	$LobbyMenu/HBoxContainer/Panel2/Disband_Leave.text = "Disband"




func _on_button_join_pressed() -> void:
	multiplayerMaster.Join(%PlayMenu/LineEdit.text)
	%LobbyMenu.visible = true
	%PlayMenu.visible = false
	

func _on_button_settings_pressed() -> void:
	state = "settings"
	pass 

func _on_button_back_pressed() -> void:
	if(state =="play"):
		$PlayMenu.visible =false
		%MainMenu.visible =true
		state = "main"


func _on_play_ready_pressed() -> void: 
	pass



func _on_disband_leave_pressed() -> void:
	multiplayerMaster.Disconnect()
	%MainMenu.visible=true
	%LobbyMenu.visible=false
