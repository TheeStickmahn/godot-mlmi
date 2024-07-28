@tool
extends Tree

var meshPath : String = ""
var exportPath : String = ""
var root : TreeItem
var children = []

@onready var debugLabel = $"../../Label"
@export var meshLibrary : MeshLibrary
func _ready():
	root = create_item()
	root.set_text(0, "Meshes")

func initializeTree():
	clear()
	debugLabel.text = ""
	if meshLibrary:
		meshLibrary.clear()
	else:
		meshLibrary = MeshLibrary.new()
	root = create_item()
	root.set_text(0, "Meshes")
	
	if meshPath != "":
		# Mesh path has been previously defined. Continue.
		pass
	else:
		# Mesh path has not been defined. Set path to the default.
		meshPath = "res://addons/mlmi/meshes/"

	var directory = DirAccess.open(meshPath)
	if directory:
		# Recursive file search. Default location is res://addons/mlmi/meshes/
		directory.list_dir_begin()
		var file_name = directory.get_next()
		
		while file_name != "":
			if directory.current_is_dir():
				print("Found directory: " + file_name + ", can't be arsed to add subdirectory support yet. Future update???")
			else:
				if file_name.find(".import") == -1: # Ignore .import file
					debugLabel.text += "Imported file: " + file_name + "\n"
					var tempChild = create_item(root)
					print(tempChild)
					tempChild.set_text(0, file_name)
					
					#/----------------------------/
					#		 JANK SHACK
					#/----------------------------/ 
						  # +
						  # A_
						 # /\-\
					#jgs  _||"|_        (thank you jgs) *smooch*
						#~^~^~^~^
					
					
					
					var gltf_state = GLTFState.new()
					var gltf_doc = GLTFDocument.new()
					gltf_doc.append_from_file(meshPath + file_name, gltf_state)
					var root_node = gltf_doc.generate_scene(gltf_state)
					var meshInstance : ImporterMeshInstance3D = root_node.get_child(0)
					
					#Goddamn this code is cursed.
					#Explanation:
					#	meshInstance.get_mesh() returns a node of type "ImporterMesh", 
					#	which needs to be converted to an "ArrayMesh" in order to use.
					#	So what this code does is convert the ImporterMesh into an ArrayMesh, which can be used for MeshLibraries.
					#	Is there a better way to do this? Probably. Do I care? No.
					# ImporterMeshInstance3D   ImporterMesh ArrayMesh
					#				↓			↓			↓
					var mesh = meshInstance.get_mesh().get_mesh()
					#	TLDR: This code returns a mesh that can be used in a MeshLibrary. Please god, kill me.
					var index = meshLibrary.get_last_unused_item_id()
					meshLibrary.create_item(index)
					meshLibrary.set_item_mesh(index, mesh)
					meshLibrary.set_item_name(index, file_name)
			file_name = directory.get_next()
	else:
		print("An error occurred when trying to access the path. Why? Don't know, don't care. That's your issue.")

func saveMeshLibrary():
	if exportPath == "":
		exportPath = "res://addons/mlmi/meshlibraries/"
	print(meshLibrary, exportPath)
	var err = ResourceSaver.save(meshLibrary, exportPath + "Exported_MeshLibrary.tres")
	if err != OK:
		printerr("Error saving MeshLibrary: " + str(err))
	else:
		debugLabel.text = "Saved MeshLibrary: " + exportPath
		meshLibrary.clear()
		clear()
