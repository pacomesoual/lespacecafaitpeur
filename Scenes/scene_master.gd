extends Node

var resourceHolder : Array

func _ready():
	#var mainMenu = loadScene("res://Scenes/menu.tscn").instantiate()
	#add_child(mainMenu)
	loadScene("res://Scenes/menu.tscn")



# "Bonjour, est ce que vous avez quelque chose dans le casier 'scenePath' sinon, ajouter le a la liste et surveillez le.

func loadScene(scenePath:String, Type=null):
	
	match ResourceLoader.load_threaded_get_status(scenePath):
		0: #la ressouce est invalide ou n'as pas encore été demandé
			ResourceLoader.load_threaded_request(scenePath)
			resourceHolder.append(scenePath)
		1: pass #la ressouce est en cours de chargement
		2: print("fuck") #la ressource a eu une erreur
		3: 
			var sceneToInstantiate = ResourceLoader.load_threaded_get(scenePath).instantiate() #la ressource a fini de chargé
			add_child(sceneToInstantiate)

func unloadScene(String):
	pass



# Essentiellement, a chaque frame physique je vérifie pour chaque entrée de 
# resourceHolder si la scene a finit de charger, si oui, je l'instantie en tant
# qu'enfant de cette scene(sceneMaster), sinon j'indique que ça charge encore.
# pour en savoir plus, voir "ResourceLoader" dans la doc.

# en cas de tentative d'optimisation, peut etre espacer de quelques frames les checks,
# comme ça ça charge moins vite (a peine ressentable) mais ça check aussi moins souvent.
func _physics_process(delta: float) -> void:
	for i in resourceHolder.size():
		match ResourceLoader.load_threaded_get_status(str(resourceHolder[i])):
			0: pass
			1: print("chargement en cours de " + str(resourceHolder[i]))
			2: print("fuck 2 electric boogaloo")
			3: 
				var sceneToInstantiate = ResourceLoader.load_threaded_get(str(resourceHolder[i])).instantiate() #la ressource a fini de chargé
				add_child(sceneToInstantiate)
				print("la scene "+ str(resourceHolder[i]) + " a fini de charger et devrait etre ajouté a la racine")
	
