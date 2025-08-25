extends CharacterBody3D
class_name Player

# --- Constantes ---
const SPEED := 5.0
const MOUSE_SENS := 0.003

# --- Nodes ---
@onready var neck: Node3D = $Neck
@onready var camera: Camera3D = $Neck/Camera3D
@onready var current_weapon: Weapon = $Neck/Weapons/Glock17 # Arme déjà présente

# --- Input ---
var mouse_locked := true

# =============================
# _ready
# =============================
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Vérifie si l'arme existe
	if current_weapon == null:
		current_weapon = $Neck/Weapons/Glock17

	# Déplace l'arme sous le Neck pour suivre la caméra
	if current_weapon != null and current_weapon.get_parent() != neck:
		current_weapon.get_parent().remove_child(current_weapon)
		neck.add_child(current_weapon)
		current_weapon.transform = Transform3D() # reset rotation
		# Pour MeshInstance3D, utiliser transform.origin ou position
		current_weapon.transform.origin = Vector3(0.5, 0, -1)
		# ou équivalent : current_weapon.position = Vector3(0.5, -0.5, -1)

# =============================
# Gestion de la souris
# =============================
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_locked:
		# Rotation horizontale du joueur
		rotate_y(-event.relative.x * MOUSE_SENS)
		# Rotation verticale du Neck
		neck.rotate_x(-event.relative.y * MOUSE_SENS)
		neck.rotation_degrees.x = clamp(neck.rotation_degrees.x, -80, 80)

	# Échap pour libérer/capturer la souris
	if event.is_action_pressed("ui_cancel"):
		mouse_locked = not mouse_locked
		if mouse_locked:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Tir et rechargement
	if event.is_action_pressed("shoot") and current_weapon:
		current_weapon.shoot()
	if event.is_action_pressed("reload") and current_weapon:
		current_weapon.reload()

# =============================
# Déplacement
# =============================
func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
