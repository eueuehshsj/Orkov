class_name WeaponSlot
extends Node2D

@onready var claw: MeleeClaw = $MeleeClaw
@onready var slugger: Slugger = $Slugger

var current_weapon: Weapon

func _ready() -> void:
	current_weapon = claw
