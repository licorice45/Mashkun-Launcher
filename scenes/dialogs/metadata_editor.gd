extends Window
var edit = false
var namer = ""
var description = ""
var filename = "test"
var tags = {"publisher": "","series": "", "year": 2000, "genre": ""}
var img_cover = null
var img_bg = null
var img_title = null
var colors = ["#1b2838", "#2c77db", "#ffffff"]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Margin/Container/Name/Margin/Container/Input.text = namer
	
	$Margin/Container/Description/Margin/Container/Input.text = description
	
	$Margin/Container/Tags/Margin/Container/Genre.text = tags["genre"]
	$Margin/Container/Tags/Margin/Container/Publisher.text = tags["publisher"]
	$Margin/Container/Tags/Margin/Container/Series.text = tags["series"]
	$Margin/Container/Tags/Margin/Container/Year.value = tags["year"]
	
	if FileAccess.file_exists("user://data/"+filename+"/cover.png") == true:
		$Margin/Container/Images/Margin/Container/BtnCover.icon = ImageTexture.create_from_image(Image.load_from_file("user://data/"+filename+"/cover.png"))
	else:
		$Margin/Container/Images/Margin/Container/BtnCover.icon = load("res://assets/textures/cover.png")
	
	if FileAccess.file_exists("user://data/"+filename+"/bg.png") == true:
		$Margin/Container/Images/Margin/Container/BtnBg.icon = ImageTexture.create_from_image(Image.load_from_file("user://data/"+filename+"/bg.png"))
	else:
		$Margin/Container/Images/Margin/Container/BtnBg.icon = load("res://assets/textures/bg.png")
	
	if FileAccess.file_exists("user://data/"+filename+"/title.png") == true:
		$Margin/Container/Images/Margin/Container/BtnTitle.icon = ImageTexture.create_from_image(Image.load_from_file("user://data/"+filename+"/title.png"))
	else:
		$Margin/Container/Images/Margin/Container/BtnTitle.icon = load("res://assets/textures/title.png")
	
	$Margin/Container/Colors/Margin/Container/Buttons/BtnPrimary.color = colors[0]
	$Margin/Container/Colors/Margin/Container/Buttons/BtnSecondary.color = colors[1]
	$Margin/Container/Colors/Margin/Container/Buttons/BtnText.color = colors[2]


func _on_close_requested():
	$".".queue_free()


func _on_btn_save_pressed():
	var img = Image.new()
	if img_cover != null:
		img_cover.save_png("user://data/"+filename+"/cover.png")
	if img_bg != null:
		img_bg.save_png("user://data/"+filename+"/bg.png")
	if img_title != null:
		img_title.save_png("user://data/"+filename+"/title.png")
	
	
	#idk if this block is needed
	if tags.has("genre") != true:
		tags["genre"] = ""
	if tags.has("publisher") != true:
		tags["publisher"] = ""
	if tags.has("series") != true:
		tags["series"] = ""
	
	
	var export_metadata = "{
	\"name\": \""+namer+"\",
	\"description\": \""+description+"\",
	\"tags\": {
		\"genre\": \""+tags["genre"]+"\",
		\"publisher\": \""+tags["publisher"]+"\",
		\"series\": \""+tags["series"]+"\",
		\"year\": "+str(tags["year"])+"
	},
	\"color\": "+ str(colors) +"
}"
	print(export_metadata)
	var metadata = FileAccess.open("user://data/"+filename+"/metadata.json", FileAccess.WRITE)
	for line in export_metadata.split("\n"):
		metadata.store_line(line)
	metadata.close()
	get_tree().get_root().get_node("Launcher").reload_data()
	$".".queue_free()


#Metadata
func _on_input_text_changed(new_text):
	namer = new_text

func _on_description_text_changed():
	description = $Margin/Container/Description/Margin/Container/Input.text

func _on_tags_changed(new_text):
	tags["publisher"] = $Margin/Container/Tags/Margin/Container/Publisher.text
	tags["genre"] = $Margin/Container/Tags/Margin/Container/Genre.text
	tags["series"] = $Margin/Container/Tags/Margin/Container/Series.text

func _on_year_value_changed(value):
	tags["year"] = $Margin/Container/Tags/Margin/Container/Year.value


func _on_btn_color_changed(color):
	colors = ["#"+$Margin/Container/Colors/Margin/Container/Buttons/BtnPrimary.color.to_html(false), "#"+$Margin/Container/Colors/Margin/Container/Buttons/BtnSecondary.color.to_html(false), "#"+$Margin/Container/Colors/Margin/Container/Buttons/BtnText.color.to_html(false)]
	print(colors)


#Images
func btn_cover_pressed():
	$FileDialog/Cover.popup()

func file_cover_selected(path):
	var img = Image.new()
	
	$Margin/Container/Images/Margin/Container/BtnCover.icon = ImageTexture.create_from_image(img.load_from_file(path))
	img_cover = img.load_from_file(path)


func btn_bg_pressed():
	$FileDialog/Bg.popup()

func file_bg_selected(path):
	var img = Image.new()
	
	$Margin/Container/Images/Margin/Container/BtnBg.icon = ImageTexture.create_from_image(img.load_from_file(path))
	img_bg = img.load_from_file(path)


func _on_btn_title_pressed():
	$FileDialog/Title.popup()

func file_title_selected(path):
	var img = Image.new()
	
	$Margin/Container/Images/Margin/Container/BtnTitle.icon = ImageTexture.create_from_image(img.load_from_file(path))
	img_title = img.load_from_file(path)
