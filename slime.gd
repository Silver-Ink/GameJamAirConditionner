extends Node2D

@onready var soft_body_2d: SoftBody2D = $SoftBody2D
@onready var texture_timer: Timer = $TextureTimer

@export var lstTextureSlime1 : Array[Texture2D]
@export var lstTextureSlime2 : Array[Texture2D]
@export var lstTextureSlime3 : Array[Texture2D]
var textureId1 = 0
var textureId2 = 0
var textureId3 = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_timer.timeout.connect(apply_next_frame)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply_next_frame():
	if (soft_body_2d.material is ShaderMaterial):
		var shaderMat : ShaderMaterial = soft_body_2d.material
		shaderMat.set_shader_parameter("slimeTexture1", lstTextureSlime1[textureId1])
		shaderMat.set_shader_parameter("slimeTexture2", lstTextureSlime2[textureId2])
		shaderMat.set_shader_parameter("slimeTexture3", lstTextureSlime3[textureId3])
		
	textureId1 = (textureId1 + 1) % lstTextureSlime1.size()
	textureId2 = (textureId2 + 1) % lstTextureSlime2.size()
	textureId3 = (textureId3 + 1) % lstTextureSlime3.size()
