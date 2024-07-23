extends Node

var settings = {
	"panel_on_left": true,
	"color_fade": true,
	"classic_list": false,
	"launch_label": "Launch",
	"sound_on": true,
	"windows_steam_directory": "steam",
	"web_directory": "start"
}

func load_settings():
	if FileAccess.file_exists("user://settings.json"):
		var data = JSON.parse_string(FileAccess.get_file_as_string("user://settings.json"))
		for setting in settings:
			if data.has(setting):
				settings[setting] = data[setting]
	else:
		save_settings(settings)
		load_settings()

func save_settings(data):
	if data["windows_steam_directory"] == "steam" && OS.get_name() == "Windows":
		data["windows_steam_directory"] = "C:/Program Files (x86)/Steam/steam.exe"
	if data["web_directory"] == "start" && OS.get_name() != "Windows":
		data["web_directory"] = "xdg-open"
	
	var metadata = FileAccess.open("user://settings.json", FileAccess.WRITE)
	metadata.store_line(JSON.stringify(data))
	metadata.close()
