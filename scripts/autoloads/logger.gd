extends Node
#
#var global_log_layer: LogLayer = LogLayer.new("", LogLevel.INFO)
#var log_layers_active: Dictionary[LogLayer]
#
#
#func register_log_layer(log_layer: LogLayer):
	#log_layers_active.append(log_layer)
#
#
#func unregister_log_layer(id: String):
	#if log_layers_active.back().id == id:
		#log_layers_active.remove_at(log_layers_active.size() - 1)
#
#
#func info(msg: String):
	#var layer: LogLayer
	#if log_layers_active.is_empty():
		#layer = global_log_layer
#
	#else:
		#layer = log_layers_active.back()
#
	#if layer.level <= LogLevel.INFO:
		#print("INFO || " + msg)
#
#
#func debug(msg: String):
	#var layer: LogLayer
	#if log_layers_active.is_empty():
		#layer = global_log_layer
#
	#else:
		#layer = log_layers_active.back()
#
	#if layer.level <= LogLevel.DEBUG:
		#print("DEBUG || " + msg)
#
#enum LogLevel {DEBUG, INFO, ERROR}
#
#
#class LogLayer:
	#var id: String
	#var level: LogLevel
#
#
	#func _init(_id: String, _level: LogLevel) -> void:
		#id = _id
		#level = _level
