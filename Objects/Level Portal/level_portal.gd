class_name LevelPortal
extends Area2D

# Active if the player meets the requirements to continue through portal
var active: bool = false

# Components
@onready var portal_frame: Sprite2D = $PortalFrame
@onready var portal_inner: AnimatedSprite2D = $PortalInner
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

signal player_activated_portal

func portal_setup():
	self.visible = false
	collision_shape.disabled = true
	self.active = false
	portal_inner.visible = false
	
func reveal():
	self.visible = true
	collision_shape.set_deferred("disabled", false)
	
func activate():
	if self.active:
		return
	
	self.active = true
	portal_inner.visible = true
	portal_inner.play('portal_open')
	self.body_entered.connect(on_player_activated.bind())

func on_player_activated(body: Node2D):
	player_activated_portal.emit()
