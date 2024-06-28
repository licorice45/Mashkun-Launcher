extends Node

var panel_on_left
var color_fade
var windows_steam_directory
var web_directory

var defaults = {
	"panel_on_left": true,
	"color_fade": true,
	"windows_steam_directory": "steam",
	"web_directory": "start"
}

func load_settings():
	if FileAccess.file_exists("user://settings.json"):
		var data = JSON.parse_string(FileAccess.get_file_as_string("user://settings.json"))
		panel_on_left = data["panel_on_left"]
		color_fade = data["color_fade"]
		windows_steam_directory = data["windows_steam_directory"]
		web_directory = data["web_directory"]
	else:
		save_settings(defaults)
		load_settings()

func save_settings(data):
	if data["windows_steam_directory"] == "steam" && OS.get_name() == "Windows":
		data["windows_steam_directory"] = "C:/Program Files (x86)/Steam/steam.exe"
	if data["web_directory"] == "start" && OS.get_name() != "Windows":
		data["web_directory"] = "xdg-open"
	
	var export_metadata = "{
	\"panel_on_left\": "+ str(data["panel_on_left"]) +",
	\"color_fade\": "+ str(data["color_fade"]) +",
	\"windows_steam_directory\": \""+ data["windows_steam_directory"] +"\",
	\"web_directory\": \""+ data["web_directory"] +"\"
}"
	var metadata = FileAccess.open("user://settings.json", FileAccess.WRITE)
	for line in export_metadata.split("\n"):
		metadata.store_line(line)
	metadata.close()
