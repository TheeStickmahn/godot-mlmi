@tool
extends EditorPlugin

const mainPanel = preload("res://addons/mlmi/MLMi.tscn")

var mainPanelInstance

func _enter_tree():
	mainPanelInstance = mainPanel.instantiate()
	EditorInterface.get_editor_main_screen().add_child(mainPanelInstance)
	_make_visible(false)


func _exit_tree():
	if mainPanelInstance:
		mainPanelInstance.queue_free()
func _has_main_screen():
	return true

func _make_visible(visible):
	if mainPanelInstance:
		mainPanelInstance.visible = visible

func _get_plugin_name():
	return "MLMi"

func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
