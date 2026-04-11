extends Node

const SETTING_SAVE_PATH = "user://settings.tres"
const DATA_SAVE_PATH = "user://data.tres"

var settings: Setting
var data: GameData

func load_data() -> void:
	if true:
		if ResourceLoader.exists(SETTING_SAVE_PATH):
			settings = ResourceLoader.load(SETTING_SAVE_PATH)
		else:
			settings = Setting.new()
			save()
	if true:
		if ResourceLoader.exists(DATA_SAVE_PATH):
			data = ResourceLoader.load(DATA_SAVE_PATH)
		else:
			data = GameData.new()
			save()
		
func save() -> void:
	ResourceSaver.save(settings, SETTING_SAVE_PATH)
	ResourceSaver.save(data, DATA_SAVE_PATH)
	
func _ready() -> void:
	load_data()

#const SAVE_PATH = "user://settings.json"
#
#var data: Dictionary[String,bool] = {
	#"auto_aim": false
#}
#
#func save_settings() -> void:
	#var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	#file.store_string(JSON.stringify(data))
#
#func load_settings() -> void:
	#if not FileAccess.file_exists(SAVE_PATH):
		#return
#
	#var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	#var content := file.get_as_text()
#
	#var result :Dictionary[String,bool] = JSON.parse_string(content)
	#if result:
		#data = result
	#
#
#func _ready()-> void:
	#load_settings()
