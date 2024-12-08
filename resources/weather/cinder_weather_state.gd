extends State

class_name WeatherState

@export var particle_number: int
@export var particle_fx: GPUParticles2D
@export var actor: Node
@export var process_material: ParticleProcessMaterial
@export var texture: Texture
@export var canvas_material: CanvasItemMaterial
@export var particle_lifetime: float

func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)
	particle_fx.process_material = process_material
	particle_fx.texture = texture
	particle_fx.material = canvas_material
	particle_fx.lifetime = particle_lifetime
	particle_fx.amount = particle_number


func exit():
	set_physics_process(false)
	particle_fx.process_material = null


#func _physics_process(delta: float) -> void:
	#pass
	
