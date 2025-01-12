extends Area3D


@export var SpringPower := 10.0
@export var ResetVelocity := false

@onready var UpDirection = global_transform.basis.y


func _on_body_entered(body: Player) -> void:

	if body.is_on_floor() and UpDirection.y <= 0.0:
		body.StateM.ChangeState("Move", {
			"Boost": UpDirection * SpringPower,
			#"UpdateModelOrientation": true,
			"IgnoreInput": 0.5,
		})
	else:
		if body.StateM.CurrentState == "Jump":
			if body.Speed > SpringPower:
				return
			
		body.global_position = global_position
		body.StateM.ChangeState("Jump", {
			"JumpForce": SpringPower,
			"IgnoreVel": ResetVelocity,
			"JumpDirection": UpDirection,
			"JumpSound": false,
		})
	
	$sndBounce.stop()
	$sndBounce.play()
