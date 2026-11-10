extends Node2D

var label_win: Label

func _ready() -> void:
	# 1. Bottom platforms
	create_platform(Vector2(120, 500), Vector2(180, 35), Color("0088cc")) # Spawn
	create_platform(Vector2(380, 520), Vector2(140, 35), Color("0088cc")) 
	create_platform(Vector2(680, 440), Vector2(220, 35), Color("0088cc"))
	create_platform(Vector2(930, 440), Vector2(110, 35), Color("0088cc")) # Goal platform

	# 2. Central/Top platforms (with the shifted and raised upper platform)
	create_platform(Vector2(260, 340), Vector2(160, 35), Color("00aaff"))
	create_platform(Vector2(500, 240), Vector2(180, 35), Color("00aaff"))
	create_platform(Vector2(780, 310), Vector2(160, 35), Color("00aaff")) # Shifted & raised

	# 3. Bottom red floor (Deadly)
	create_death_zone(Vector2(600, 620), Vector2(1400, 60))

	# 4. Thicker top red ceiling (Deadly)
	create_death_zone(Vector2(600, -40), Vector2(1400, 100))

	# 5. Green Win Zone at the end
	create_win_zone(Vector2(970, 395), Vector2(50, 50))

	# 6. Victory UI Setup
	setup_win_ui()

func create_platform(pos: Vector2, size: Vector2, color: Color) -> void:
	var body = StaticBody2D.new()
	body.position = pos
	var col = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = size
	col.shape = rect
	body.add_child(col)
	var visual = ColorRect.new()
	visual.size = size
	visual.position = -size / 2
	visual.color = color
	body.add_child(visual)
	add_child(body)

func create_death_zone(pos: Vector2, size: Vector2) -> void:
	var area = Area2D.new()
	area.position = pos
	var col = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = size
	col.shape = rect
	area.add_child(col)
	var visual = ColorRect.new()
	visual.size = size
	visual.position = -size / 2
	visual.color = Color("ff2222") # Danger red
	area.add_child(visual)
	area.body_entered.connect(_on_death_zone_entered)
	add_child(area)

func create_win_zone(pos: Vector2, size: Vector2) -> void:
	var area = Area2D.new()
	area.position = pos
	var col = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = size
	col.shape = rect
	area.add_child(col)
	var visual = ColorRect.new()
	visual.size = size
	visual.position = -size / 2
	visual.color = Color("00ff66") # Win green
	area.add_child(visual)
	area.body_entered.connect(_on_win_zone_entered)
	add_child(area)

func setup_win_ui() -> void:
	var canvas = CanvasLayer.new()
	add_child(canvas)
	
	label_win = Label.new()
	label_win.text = "LEVEL COMPLETED!"
	label_win.visible = false
	label_win.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_win.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label_win.set_anchors_preset(Control.PRESET_CENTER)
	
	label_win.add_theme_font_size_override("font_size", 64)
	label_win.add_theme_color_override("font_color", Color("00ff66"))
	canvas.add_child(label_win)

func _on_death_zone_entered(body: Node2D) -> void:
	if body.name == "player":
		body.die()

func _on_win_zone_entered(body: Node2D) -> void:
	if body.name == "player":
		label_win.visible = true
		get_tree().paused = true
