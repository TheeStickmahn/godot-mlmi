@tool
extends VBoxContainer
@onready var meshDetailsLabel = $MeshDetails
@onready var meshNameLabel = $MeshName
@onready var tree = $"../../PanelContainer2/ScrollContainer/Tree"
var treeMeshLibrary

func _ready():
	treeMeshLibrary = tree.meshLibrary

func _on_tree_item_selected():
	var selected : TreeItem = tree.get_selected()
	var selectedName : String = selected.get_text(0)
	
	#Please god forgive me.
	var faceCount = treeMeshLibrary.get_item_mesh(selected.get_index()).get_faces().size() / 3
	meshDetailsLabel.text = "[i]Face count: " + str(faceCount)
	meshNameLabel.text = selectedName
