extends Node




@export var port = 7777
var address : String = "0.0.0.0"
var peer
var clientOrHost : String
var myID : String
var playerCount




func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.server_disconnected.connect(server_disconnected)
	
	
	
func peer_connected(id):
	pass


#this get called on both when client disconnect
func peer_disconnected(id):
	if(clientOrHost=="Host"):
		print(str(id) + " left...")
	pass


#this called only from client when succeed.
func connected_to_server():
	print("connected successfully")
	pass


#this called only from client when failed.
func connection_failed():
	print("connection failed")
	pass
	

func server_disconnected():
	print("server disconnected")
	pass


func Host():
	peer = ENetMultiplayerPeer.new()  #de la magie noire
	var error = peer.create_server(port, 8)  #pour s'assurer que la magie noire fonctionne
	if error != OK:
		print("cannot host " + str(error))
		return
	multiplayer.set_multiplayer_peer(peer) #confirme le rituel
	clientOrHost = "Host"          #tente déséspérément d'identifier si on est le sacrifice ou le cultiste
	print(clientOrHost + " "+ ": Waiting for players!")      #appel a l'aide


func Join(address):
	print("trying to join " + str(address))    #appel  a l'aide
	peer = ENetMultiplayerPeer.new()             #magie noire
	var joinerror = peer.create_client(address, port)   #assure que la magie noire fonctionne et appel a l'aide sinon.
	if joinerror != OK:
		print("oh no " + joinerror)
		return
	clientOrHost = "Client"
	multiplayer.set_multiplayer_peer(peer)     #magie noire bis


func Disconnect():
	if(clientOrHost=="Host"):
		peer.close()
		return("done")
		
	if(clientOrHost=="Client"):
		peer.close()
		return("done")
