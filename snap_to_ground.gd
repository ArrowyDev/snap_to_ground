@tool
extends EditorPlugin

var button: Button

func _enter_tree():
	button = Button.new()
	button.icon = preload("res://addons/snap_to_ground/btnicon.png")
	button.pressed.connect(_on_snap_pressed)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, button)

func _exit_tree():
	if button:
		remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, button)
		button.queue_free()

func _on_snap_pressed():
	var selected = get_editor_interface().get_selection().get_selected_nodes()
	for node in selected:
		if node is Node3D:
			snap_to_mesh(node)

func snap_to_mesh(node: Node3D):
	var pivot_to_bottom = get_bottom_offset(node)
	var bottom_world_y = node.global_position.y + pivot_to_bottom
	var ray_origin = Vector3(node.global_position.x, bottom_world_y, node.global_position.z)
	var root = get_editor_interface().get_edited_scene_root()
	if root == null:
		return
	var meshes = get_all_mesh_instances(root)
	var best_y = null
	for mesh_instance in meshes:
		if mesh_instance == node:
			continue
		if is_child_of(mesh_instance, node):
			continue
		if mesh_instance.mesh == null:
			continue
		var y = raycast_against_mesh(ray_origin, mesh_instance)
		if y != null:
			if y <= bottom_world_y + 0.01:
				if best_y == null or y > best_y:
					best_y = y
	if best_y != null:
		node.global_position.y = best_y - pivot_to_bottom
	else:
		node.global_position.y = -pivot_to_bottom

func get_bottom_offset(node: Node3D) -> float:
	var meshes = get_all_mesh_instances(node)
	if meshes.is_empty():
		return 0.0
	var min_y = INF
	for mi in meshes:
		if mi.mesh == null:
			continue
		var aabb = mi.get_aabb()
		var global_aabb = mi.global_transform * aabb
		var bottom = global_aabb.position.y
		if bottom < min_y:
			min_y = bottom
	if min_y == INF:
		return 0.0
	return min_y - node.global_position.y

func is_child_of(node: Node, parent: Node) -> bool:
	var current = node.get_parent()
	while current != null:
		if current == parent:
			return true
		current = current.get_parent()
	return false

func raycast_against_mesh(origin: Vector3, mesh_instance: MeshInstance3D):
	var mesh = mesh_instance.mesh
	var transform = mesh_instance.global_transform
	var local_origin = transform.affine_inverse() * origin
	var local_dir = transform.basis.inverse() * Vector3.DOWN
	local_dir = local_dir.normalized()
	var faces = mesh.get_faces()
	if faces.is_empty():
		return null
	var best_y = null
	var i = 0
	while i + 2 < faces.size():
		var v0 = faces[i]
		var v1 = faces[i + 1]
		var v2 = faces[i + 2]
		i += 3
		var result = ray_triangle_intersect(local_origin, local_dir, v0, v1, v2)
		if result != null:
			var world_point = transform * result
			var world_y = world_point.y
			if best_y == null or world_y > best_y:
				best_y = world_y
	return best_y

func ray_triangle_intersect(origin: Vector3, dir: Vector3, v0: Vector3, v1: Vector3, v2: Vector3):
	var epsilon = 0.0000001
	var edge1 = v1 - v0
	var edge2 = v2 - v0
	var h = dir.cross(edge2)
	var a = edge1.dot(h)
	if abs(a) < epsilon:
		return null
	var f = 1.0 / a
	var s = origin - v0
	var u = f * s.dot(h)
	if u < 0.0 or u > 1.0:
		return null
	var q = s.cross(edge1)
	var v = f * dir.dot(q)
	if v < 0.0 or u + v > 1.0:
		return null
	var t = f * edge2.dot(q)
	if t > epsilon:
		return origin + dir * t
	return null

func get_all_mesh_instances(node: Node) -> Array:
	var result = []
	if node is MeshInstance3D:
		result.append(node)
	for child in node.get_children():
		result += get_all_mesh_instances(child)
	return result
