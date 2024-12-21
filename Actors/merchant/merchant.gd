# AUTHOR: ANGEL SANTIAGO - DEC 2, 2024
extends Sprite2D

class_name Merchant

# VARIABLES
var can_trigger_merchant_ui = false #prevents telepathic merchant

# REFERENCES
@onready var merchant_label: Label = $MerchantLabel
@onready var merchant_ui: CanvasLayer = $MerchantUi

# FUNCTIONS
func _ready() -> void:
	Global.init_stock()
	merchant_ui.setup_buying_grid()
	
func _on_area_2d_body_entered(_body: Node2D) -> void:
	can_trigger_merchant_ui = true
	merchant_label.visible = true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	can_trigger_merchant_ui = false
	merchant_label.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('shop_toggle') and can_trigger_merchant_ui:
		merchant_ui.visible = true
		var player = (get_tree().get_first_node_in_group("Player") as Player)
		merchant_ui.items_to_sell = (player.find_child("Inventory") as Inventory).items
		merchant_ui.setup_selling_grid()
	
	
	if event.is_action_pressed("ui_accept") && merchant_ui.visible:
		merchant_ui.visible = false
