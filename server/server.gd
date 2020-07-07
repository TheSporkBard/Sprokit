extends Node2D

onready var cmdargs =  OS.get_cmdline_args()
const defport = 6667
var _server = WebSocketServer.new()
var clients = {}

func _ready():
	#Get the port from command line if available or set to the default port (6667)
	var port
	if cmdargs.size() == 0:
		print("no port selected")
		port = defport
		print("using %d instead" % [defport])
	elif int(cmdargs[0]):
		port = int(cmdargs[0])
		print("using port : %d" % [port])
	else:
		port = defport
	#Connect the servers signals to the correct functions
	_server.connect("client_connected", self, "_connected")
	_server.connect("client_disconnected", self, "_disconnected")
	_server.connect("client_close_request", self, "_close_request")
	_server.connect("data_received", self, "_on_data")
	#Start listening on the given port
	var err = _server.listen(port)
	if err != OK:
		print("Unable to start server")
		set_process(false)

func _connected(id,proto):
	print("%d, connected with protocol: %s" % [id, proto])

func _disconnected(id,clean = false):
	print("%d, disconnected, was it clean? : %s" % [id, clean])

func _close_request(id, code, reason):
	print("%d requested to disconnect because %d, code: %s" %[id, reason, code])

func _on_data(id):
	var pkt = _server.get_peer(id).get_packet()
	var usablepacket = pkt.get_string_from_utf8().split("-")
	print("%d sent data: %s" % [id,usablepacket])
	match usablepacket[0]:
		"gendata":
			pass
		"register":
			pass
		"login":
			clients[id] = Thread.new()
			clients.get(id).start(self,"_clientcontrol", usablepacket)
		_:
			print(id, "has done it wrong remove them, NOW")
			_server.disconnect_peer(id,66,"You did that wrong buddy :)")

func _clientcontrol(userdata):
	var cli = preload("res://client.tscn").instance()
	if !cli.Load(userdata[1],userdata[2]):
		print("huh")
	else:
		print("logged in")
	print("somthing")

# warning-ignore:unused_argument
func _process(delta):
	_server.poll()
