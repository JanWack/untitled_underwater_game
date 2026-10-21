extends Node3D

@export var height_map: NoiseTexture2D
@export var height_multiplier: float
@export var length_multiplier: float
@export var color_gradient: Gradient

@export var water: MeshInstance3D
@export var max_depth: float
@export var island_height_cutoff: Curve
var water_animation: float = 0

var noise_image: Image
var center_offset: Vector2
var rand: RandomNumberGenerator = RandomNumberGenerator.new()
var st: SurfaceTool = SurfaceTool.new()

var terrain_meshes: Array[MeshInstance3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var plane: PlaneMesh = water.mesh
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	await height_map.changed
	noise_image = height_map.get_image()
	center_offset = (noise_image.get_size() * length_multiplier) / 2
	
	plane.size = noise_image.get_size() * length_multiplier
	
	generate_terrain()

func generate_terrain() -> void:
	var map_size: Vector2 = noise_image.get_size()
	
	var min_x = 0
	var min_y = 0
	var max_x = map_size.x
	var max_y = map_size.y
	
	for x in range(min_x, max_x, ):
		for y in range(min_y, max_y):
			var vertices = get_coordinate_vertices(x, y)
			var vertex_colors = get_vertices_color(x, y)
			for i in range(6):
				st.set_color(vertex_colors[i])
				#st.set_normal(Vector3(0, 1, 0))
				st.set_uv(Vector2(0, 0))
				st.add_vertex(vertices[i])
	commit_mesh()

func commit_mesh() -> void:
	st.generate_normals()
	st.generate_tangents()
	var mesh = st.commit()
	var mi = MeshInstance3D.new()
	var mat = StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mi.material_override = mat
	mi.mesh=mesh
	add_child(mi, true)
	#terrain_meshes.append(mi)
	mi.create_trimesh_collision()

func get_coordinate_vertices(x:int, y:int) -> Array[Vector3]:
	var vertex_array: Array[Vector3]
	
	var vertex1 = get_vertex_point(x, y)
	var vertex2 = get_vertex_point(x+1, y)
	var vertex3 = get_vertex_point(x, y+1)
	var vertex4 = get_vertex_point(x+1, y+1)
	
	vertex_array.append(vertex1)
	vertex_array.append(vertex2)
	vertex_array.append(vertex3)
	vertex_array.append(vertex4)
	vertex_array.append(vertex3)
	vertex_array.append(vertex2)
	
	return vertex_array

func get_vertices_color(x:int, y:int) -> Array[Color]:
	var color_array: Array[Color]
	
	var color1 = get_vertex_color(x, y)
	var color2 = get_vertex_color(x+1, y)
	var color3 = get_vertex_color(x, y+1)
	var color4 = get_vertex_color(x+1, y+1)
	
	color_array.append(color1)
	color_array.append(color2)
	color_array.append(color3)
	color_array.append(color4)
	color_array.append(color3)
	color_array.append(color2)
	
	return color_array

# Gets the point of the vertex where x and z account for length_multiplyer
# and y is the noise value * height_multiplyer
func get_vertex_point(x: int, y: int) -> Vector3:
	var X = length_multiplier * x - center_offset.x
	var Y = length_multiplier * y - center_offset.y
	var height_map_value = noise_image.get_pixel(x, y).r
	var island_height = island_height_cutoff.sample(height_map_value)
	var height = -max_depth + (max_depth * island_height) + (height_multiplier * height_map_value)
	return Vector3(X, height, Y)

func get_vertex_color(x: int, y: int) -> Color:
	return color_gradient.sample(noise_image.get_pixel(x, y).r)# + Color.WHITE_SMOKE*abs(rand.randf_range(0, 0.01))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	water.position.y = sin(water_animation)/10
	water_animation += delta
