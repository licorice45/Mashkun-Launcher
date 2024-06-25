extends Window
@onready var input = $Margin/Container/Input
var namer
var date
var publisher
var download_progress = 0

func _on_button_pressed():
	input.editable = false
	$Margin/Container/BtnLoad.disabled = true
	DirAccess.make_dir_absolute("user://data/"+input.text+"/")
	$HTTP/title.request("https://steamcdn-a.akamaihd.net/steam/apps/"+input.text+"/logo.png")
	$HTTP/cover.request("https://steamcdn-a.akamaihd.net/steam/apps/"+input.text+"/library_600x900.jpg")
	$HTTP/bg.request("https://steamcdn-a.akamaihd.net/steam/apps/"+input.text+"/library_hero.jpg")
	$Margin/Container/Label.text = "Progress: (0/4)"

func _on_line_edit_text_changed(new_text):
	if new_text != "":
		$Margin/Container/BtnLoad.disabled = false
	else:
		$Margin/Container/BtnLoad.disabled = true

func download(result, body, ispng):
	var img = Image.new()
	if ispng == true:
		img.load_png_from_buffer(body)
	else:
		img.load_jpg_from_buffer(body)
	return img

func title_request_done(result, response_code, headers, body):
	var img = download(result, body, true)
	img.save_png("user://data/" + input.text + "/title.png")
	results_update()


func cover_request_done(result, response_code, headers, body):
	var img = download(result, body, false)
	img.save_png("user://data/" + input.text + "/cover.png")
	results_update()


func bg_request_done(result, response_code, headers, body):
	var img = download(result, body, false)
	img.save_png("user://data/" + input.text + "/bg.png")
	results_update()


func steampage_request_done(result, response_code, headers, body):
	var n = 0
	var publisher_n = -1
	for line in body.get_string_from_utf8().split("\n"):
		if line.contains("itemprop=\"name\"") == true:
			namer = line.split("itemprop=\"name\">")[1].split("</span>")[0]
		if line.contains("<b>Release Date:</b>") == true:
			date = line.split(", ")[1].split("<br>")[0]
		if line.contains("Publisher:</div>"):
			publisher_n = n + 2
		if n == publisher_n:
			publisher = line.split(">")[1].split("</a")[0]
		n += 1
	
	var export_metadata = "{
	\"name\": \""+namer+"\",
	\"tags\": {
		\"publisher\": \""+publisher+"\",
		\"year\": "+date+"
	},
	\"color\": [\"#1B2838\", \"#2C77DB\", \"#ffffff\"]
}"
	
	var export_command = "{
	\"command\": \"steam\",
	\"arguments\": [
		\"-applaunch\", \""+input.text+"\"
	]
}"
	
	var metadata = FileAccess.open("user://data/"+input.text+"/metadata.json", FileAccess.WRITE)
	for line in export_metadata.split("\n"):
		metadata.store_line(line)
	metadata.close()
	
	var command = FileAccess.open("user://data/"+input.text+"/command.json", FileAccess.WRITE)
	for line in export_command.split("\n"):
		command.store_line(line)
	command.close()	
	
	var order_read = JSON.parse_string(FileAccess.get_file_as_string("user://data/order.json"))
	order_read.append([input.text])
	
	var order = FileAccess.open("user://data/order.json", FileAccess.WRITE)
	order.store_line(str(order_read))
	order.close()
	
	results_update()


func _on_close_requested():
	if input.editable == true:
		$".".queue_free()

func results_update():
	
	download_progress += 1
	$Margin/Container/Label.text = "Progress: (" + str(download_progress) + "/4)"
	if download_progress >= 3:
		$HTTP/steampage.request("https://store.steampowered.com/app/"+input.text)
	if download_progress >= 4:
		get_tree().get_root().get_node("Launcher").reload_data()
		$".".queue_free()


func _on_input_text_submitted(new_text):
	if $Margin/Container/BtnLoad.disabled != true:
		_on_button_pressed()
