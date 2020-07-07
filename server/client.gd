extends Node2D

var usr
var ps

var pos_x
var pos_y
var room
var Class
var job
var current_hp
var max_hp
var current_mp
var max_mp
var current_stm
var max_stm
var expr
var lvl 
var inv = {}
var ept = {}
var node_data_out
var poslocked = false

var public_data
var private_data

func newUser(username,password,classt):
	usr = username
	ps = password
	pos_x = Classlist.Class[classt].spawnpoints["spawn"].x
	pos_y = Classlist.Class[classt].spawnpoints["spawn"].y
	room = Classlist.Class[classt].spawnpoints["room"]
	current_hp = Classlist.Class[classt].BaseData["hp"]
	max_hp = Classlist.Class[classt].BaseData["hp"]
	current_mp = Classlist.Class[classt].BaseData["mp"]
	max_mp = Classlist.Class[classt].BaseData["mp"]
	print(current_mp, max_mp)
	current_stm = Classlist.Class[classt].BaseData["stm"]
	max_stm = Classlist.Class[classt].BaseData["stm"]
	Class = Classlist.Class[classt].BaseData["displayname"]
	job = "None"
	expr = 0
	lvl = 1
	Save()
	return Load(usr, ps)

func Load(usrt, pst):
	usr = usrt
	var save_game = File.new()
	if not save_game.file_exists("user://"+usr+".save"):
		 return false
	save_game.open("user://"+usr+".save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		
		ps =node_data["pss"]
		usr = node_data["username"]
		pos_x = node_data["pos_x"]
		pos_y = node_data["pos_y"]
		room = node_data["room"]
		Class = node_data["Class"]
		job = node_data["job"]
		current_hp = node_data["current_health"]
		max_hp = node_data["max_health"]
		current_mp = node_data["current_mana"]
		max_mp = node_data["max_mana"]
		current_stm = node_data["current_stamina"]
		max_stm = node_data["max_stamina"]
		expr = node_data["experience"]
		lvl = node_data["level"]
		inv  = parse_json(node_data["inv"])
		ept  = parse_json(node_data["equipment"])
		node_data_out = node_data
	if ps == pst and usr == usrt:
		public_data = {
		"username" : usr,
		"pos_x" : pos_x, # Vector2 is not supported by JSON
		"pos_y" : pos_y,
		"room" : room,
		"class" : Class,
		"job" : job,
		"current_health" : current_hp,
		"max_health" : max_hp,
		"current_mana" : current_mp,
		"max_mana" : max_mp,
		"current_stamina" : current_stm,
		"max_stamina" : max_stm,
		"level" : lvl,
		}
		private_data = {
		"experience" : expr,
		"inv": to_json(inv),
		"equipment": to_json(ept)
		}
		return true
	else:
		save_game.close()
		return false


func Save():
	var save_client = File.new()
	save_client.open("user://"+usr+".save", File.WRITE)
	var save_dict = {
		"username" : usr,
		"pss" : ps,
		"pos_x" : pos_x, # Vector2 is not supported by JSON
		"pos_y" : pos_y,
		"room" : room,
		"Class" : Class,
		"job" : job,
		"current_health" : current_hp,
		"max_health" : max_hp,
		"current_mana" : current_mp,
		"max_mana" : max_mp,
		"current_stamina" : current_stm,
		"max_stamina" : max_stm,
		"experience" : expr,
		"level" : lvl,
		"inv": to_json(inv),
		"equipment": to_json(ept)
	}
	save_client.store_line(to_json(save_dict))
	save_client.close()
