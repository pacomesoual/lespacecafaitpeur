extends Control




# Déclaration de variables pour la connection et le comptage de joueurs
@export var port = 7777
var address : String = "0.0.0.0"
var peer
var ClientOrHost : String
var pPosition : Array  #array contenant les différents "slots" que peuvent occuper les joueurs visuellement dans le lobby.
var state = "main"     #Main c'est qu'on est dans le menu principal, play c'est le menu de connection, settings c'est les options.
var myID : String

func _ready():
	
	#Relie les signaux aux fonctions appropriés.
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.server_disconnected.connect(server_disconnected)
	%PlayMenu.visible = false
	$LobbyMenu.visible = false
	pPosition =  [$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer/PlayerContainer1,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer/PlayerContainer2,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer/PlayerContainer3,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer/PlayerContainer4,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer2/PlayerContainer5,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer2/PlayerContainer6,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer2/PlayerContainer7,$LobbyMenu/HBoxContainer/PlayerDisplayer/HBoxContainer/VBoxContainer2/PlayerContainer8]
	

func _process(delta: float) -> void:
	
	# Affiche le nombre de joueur en temps réel :
	$LobbyMenu/HBoxContainer/Panel2/Disband_Leave.text = str(multiplayer.get_peers().size()+1)

# FONCTIONS DE CONNECTION AUTOMATIQUES :
#this gets called on the server and clients when client connects
func peer_connected(id):
	pass


#this get called on both when client disconnect
func peer_disconnected(id):
	if(ClientOrHost=="Host"):
		print(str(id) + " left...")
	pass


#this called only from client when succeed.
func connected_to_server():
	$LobbyMenu.visible = true
	%PlayMenu.visible = false
	pass


#this called only from client when failed.
func connection_failed():
	print("connection failed")
	pass
	

func server_disconnected(id):
	print("server disconnected")
	pass


## LES BOUTONS DU MENU :


func _on_button_quit_pressed() -> void:
	get_tree().quit()  

func _on_button_play_pressed() -> void:
	state = "play"
	%PlayMenu.visible =true
	%MainMenu.visible =false
	
	
	pass

func _on_button_host_pressed() -> void:
	peer = ENetMultiplayerPeer.new()  #de la magie noire
	var error = peer.create_server(port, 8)  #pour s'assurer que la magie noire fonctionne
	if error != OK:
		print("cannot host " + str(error))
		return
	multiplayer.set_multiplayer_peer(peer) #confirme le rituel
	ClientOrHost = "Host"          #tente déséspérément d'identifier si on est le sacrifice ou le cultiste
	print(ClientOrHost + " "+ ": Waiting for players!")      #appel a l'aide
	$LobbyMenu.visible = true
	%PlayMenu.visible = false
	$LobbyMenu/HBoxContainer/Panel2/Play_Ready.text = "Play"
	$LobbyMenu/HBoxContainer/Panel2/Disband_Leave.text = "Disband"




func _on_button_join_pressed() -> void:
	address = str($PlayMenu/LineEdit.text) #tente de se rappeler dans quelle sphere de l'enfer on va
	print("trying to join " + str(address))    #appel  a l'aide
	peer = ENetMultiplayerPeer.new()             #magie noire
	var joinerror = peer.create_client(address, port)   #assure que la magie noire fonctionne et appel a l'aide sinon.
	if joinerror != OK:
		print("oh no " + joinerror)
		return
	
	ClientOrHost = "Client"
	multiplayer.set_multiplayer_peer(peer)     #magie noire bis
	

func _on_button_settings_pressed() -> void:
	state = "settings"
	pass 

func _on_button_back_pressed() -> void:
	if(state =="play"):
		$PlayMenu.visible =false
		%MainMenu.visible =true
		state = "main"


func _on_play_ready_pressed() -> void: 
	if(multiplayer.get_unique_id()==1):
		pass



func _on_disband_leave_pressed() -> void:
	if(ClientOrHost=="Host"):
		peer.close()
		%MainMenu.visible=true
		%LobbyMenu.visible=false
		
	if(ClientOrHost=="Client"):
		peer.close()
		%MainMenu.visible=true
		%LobbyMenu.visible=false
