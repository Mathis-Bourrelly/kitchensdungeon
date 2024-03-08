extends CharacterBody3D


const SPEED = 7.0
const JUMP_VELOCITY = 5.0
const MOUSE_SENSITIVITY = 0.002
const MAX_CAM_ANGLE_UP:float = deg_to_rad(60)
const MAX_CAM_ANGLE_DOWN:float = -deg_to_rad(75)
var mouse_captured:bool = false
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var highlighted_objects:Array = []
var already_highlighted:bool = false

var current_item
var current_tool
var pull_power = 20
var throw_power = 1.5
var throw_up_power = 0.5

signal droped_on_slot(snapped_item)

@onready var camera:Camera3D = $Head/Camera
@onready var head:Node3D = $Head
@onready var interaction:RayCast3D = $Head/Camera/Interaction
@onready var hand_item:Node3D = $Head/Camera/HandItem
@onready var hand_tool:Node3D = $Head/Camera/HandTool
@onready var hand_bowl:Node3D = $Head/Camera/HandBowl
@onready var item_joint:Generic6DOFJoint3D = $Head/Camera/HandItem/ItemJoint
@onready var tool_joint:Generic6DOFJoint3D = $Head/Camera/HandTool/ToolJoint
@onready var bowl_joint:Generic6DOFJoint3D = $Head/Camera/HandBowl/BowlJoint

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true
	
func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _ready():
	capture_mouse()

func _input(event):
	if event is InputEventMouseMotion and mouse_captured:
		head.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clampf(camera.rotation.x, MAX_CAM_ANGLE_DOWN, MAX_CAM_ANGLE_UP)

func _physics_process(delta):
		
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("player_grab"):
		if current_item == null:
			grab_item()
		elif current_item != null:
			drop_item()
	if Input.is_action_just_pressed("player_throw"):
		action_item()
		throw_item()
		
	if Input.is_action_just_pressed("player_swap_hand"):
		swap_hand()
	
	highlight()
	
	var input_dir = Input.get_vector("player_left", "player_right", "player_forward", "player_backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if (!mouse_captured): capture_mouse()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if mouse_captured:
		var joypad_dir:Vector2 = Input.get_vector("player_look_left","player_look_right","player_look_up","player_look_down")
		if joypad_dir.length() > 0:
			var look_dir = joypad_dir * delta
			head.rotate_y(-look_dir.x * 3.5)
			camera.rotate_x(-look_dir.y * 2.0)
			camera.rotation.x = clamp(camera.rotation.x - look_dir.y, MAX_CAM_ANGLE_DOWN, MAX_CAM_ANGLE_UP)
	

	if current_item != null:
		var a = current_item.global_position
		var b = hand_item.global_position
		var c = a.distance_to(b)
		var calc = (a.direction_to(b))*pull_power*c
		current_item.set_linear_velocity(calc)
		
	if current_tool != null:
		if current_tool.is_in_group("bowl"):
			var a = current_tool.global_position
			var b = hand_bowl.global_position
			var c = a.distance_to(b)
			var calc = (a.direction_to(b))*pull_power*c
			current_tool.set_linear_velocity(calc)
		if current_tool.is_in_group("knife"):
			var a = current_tool.global_position
			var b = hand_tool.global_position
			var c = a.distance_to(b)
			var calc = (a.direction_to(b))*pull_power*c
			current_tool.set_linear_velocity(calc)

func throw_item():
	var collider = interaction.get_collider()
	if collider != null:
		if current_item != null:
			var knockback = current_item.global_position - (head.global_position - Vector3(0.0,throw_up_power,0.0))
			current_item.apply_central_impulse(knockback * throw_power)
			drop_item()


func action_item():
	var collider = interaction.get_collider()
	if collider != null:
		if collider is Item and collider.slot != null:
			collider.slot.action()
		if current_tool != null and current_tool.is_in_group("bowl") and collider.is_in_group("step"):
			if current_tool.accepted_step.has(collider.get_groups()[2]):
				if current_tool.add_step(collider):
					collider.queue_free()

		if collider.is_in_group("ring"):
			collider.send_meal()
		

func drop_item():
	if current_item != null:
		item_joint.set_node_b(item_joint.get_path())
		current_item.is_taken = false
		if current_item.slot != null:
			droped_on_slot.emit(current_item)
		current_item = null
		
func drop_tool():
	if not interaction.is_colliding():
		if current_tool != null:
			tool_joint.set_node_b(tool_joint.get_path())
			bowl_joint.set_node_b(bowl_joint.get_path())
			current_tool.is_taken = false
			if current_tool.slot != null:
				droped_on_slot.emit(current_tool)
			current_tool.set_collision_mask_value(2,true)
			current_tool = null
		
func grab_item():
	if interaction.is_colliding():
		var collider = interaction.get_collider()
		if collider != null and collider is Item:
			if collider.is_in_group("tool"):
				if current_tool == null:
					if collider.is_in_group("bowl"):
						check_slot(collider)
						current_tool = collider
						current_tool.is_taken = true
						current_tool.global_rotation = hand_bowl.global_rotation
						bowl_joint.set_node_b(current_tool.get_path())
						current_tool.set_collision_mask_value(2,false)
					if collider.is_in_group("knife"):
						check_slot(collider)
						current_tool = collider
						current_tool.is_taken = true
						current_tool.global_rotation = hand_tool.global_rotation
						tool_joint.set_node_b(current_tool.get_path())
						current_tool.set_collision_mask_value(2,false)
			else:
				check_slot(collider)
				current_item = collider
				collider.is_taken = true
				item_joint.set_node_b(current_item.get_path())
				
		if collider != null and collider is Crate:
			var new_item = collider.spawn_item(collider.item_to_spawn)
			current_item = new_item
			new_item.is_taken = true
			addhighlight(new_item)
			removehighlight(collider)
			item_joint.set_node_b(new_item.get_path())
		if collider != null and collider.is_in_group("rack"):
			var new_item = collider.spawn_item(collider.item_to_spawn)
			new_item.global_rotation = hand_bowl.global_rotation
			current_tool = new_item
			new_item.is_taken = true
			addhighlight(new_item)
			removehighlight(collider)
			bowl_joint.set_node_b(new_item.get_path())


func check_slot(collider):
	if collider.is_freeze_enabled() and collider.slot != null:
		collider.set_freeze_enabled(false)
		collider.slot = null

func swap_hand():
	if current_tool != null:
		current_tool.global_rotation = Vector3(0,0,0)
		tool_joint.set_node_b(tool_joint.get_path())
		bowl_joint.set_node_b(bowl_joint.get_path())
		item_joint.set_node_b(current_tool.get_path())
		current_item = current_tool
		current_tool = null
	else:
		if current_item != null and current_item.is_in_group("tool"):
			if current_item.is_in_group("bowl"):
				print(hand_bowl.global_rotation)
				current_item.global_rotation = hand_bowl.global_rotation
				bowl_joint.set_node_b(current_item.get_path())
				item_joint.set_node_b(item_joint.get_path())
			if current_item.is_in_group("knife"):
				print(hand_tool.global_rotation)
				current_item.global_rotation = hand_tool.global_rotation
				tool_joint.set_node_b(current_item.get_path())
				item_joint.set_node_b(item_joint.get_path())
			current_tool = current_item
			current_item = null

func highlight():
	if current_item == null:
		var collider = interaction.get_collider()
		if collider != null and collider.is_in_group("highlightable"):
			if collider not in highlighted_objects:
				removehighlight_all()
				addhighlight(collider)
		else:
			removehighlight_all()

func addhighlight(current_collider):
	current_collider.mesh.set_surface_override_material(0,load("res://assets/materials/highlight.tres"))
	highlighted_objects.append(current_collider)

func removehighlight(object):
	object.mesh.set_surface_override_material(0,null)

func removehighlight_all():
	# Retirer le surlignage de tous les objets dans la liste
	for object in highlighted_objects:
		if object != null:
			object.mesh.set_surface_override_material(0,null)
	# Effacer la liste des objets surlignés
	highlighted_objects.clear()
