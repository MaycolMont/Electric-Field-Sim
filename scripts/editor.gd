extends Node2D

var _default_charge : int = 30
enum STATE {ADD, SIM, EDIT}

func _on_electron_button_pressed():
	$Field.add_particle(-_default_charge)

func _on_proton_button_pressed():
	$Field.add_particle(_default_charge)
