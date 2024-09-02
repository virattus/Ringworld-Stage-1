extends "res://entities/Sonic/MoveAir.gd"




func Enter(_msg := {}) -> void:
	if _msg.has("JumpSound") and _msg["JumpSound"] != true:
		pass
	else:
		owner.SndJump.play()
	
	var JumpForce = owner.PARAMETERS.JUMP_POWER
	if owner.IsUnderwater:
		JumpForce = owner.PARAMETERS.JUMP_POWER / 3.0
	
	if _msg.has("JumpForce"):
		JumpForce = _msg["JumpForce"]
	
	if _msg.has("JumpDirection"):
		owner.up_direction = _msg["JumpDirection"]
		owner.CharMesh.AlignToY(owner.up_direction)

	var newVel : Vector3 = owner.velocity
	if _msg.has("IgnoreVel") and _msg["IgnoreVel"] == true:
		newVel = Vector3.ZERO
	
	#Set velocity to only forward direction + jump direction, fixes bug with jumping after circling sphere
	#thanks to https://gamedev.stackexchange.com/questions/198103/how-can-i-zero-out-velocity-in-an-arbitrary-direction
	#Up direction should be normalised, but not newVel
	var frontVel = newVel - (owner.up_direction * owner.up_direction.dot(newVel))
	newVel = frontVel + owner.up_direction * JumpForce
	
	owner.SetVelocity(newVel)
	
	owner.CharMesh.LookAt(owner.global_position + frontVel.normalized())
	owner.CharMesh.AlignToY(owner.up_direction)
	
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", -1.0)
	
	owner.GroundCollision = false
	owner.HasJumped = true
	
	print("Jumped")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision : SonicCollision = owner.GetCollision()
	if CheckGroundCollision(collision):
		#We landed while travelling up, this should probably never happen
		return
	
	if Input.is_action_just_pressed("Jump"):
		if owner.IsUnderwater:
			ChangeState("Jump")
			return
		else:
			if Input.is_action_just_pressed("Attack"):
				ChangeState("Pose")
				return
			else:
				ChangeState("Airdash")
				return
	
	if Input.is_action_just_pressed("Attack"):
		if owner.DashMode:
			ChangeState("SpinKick")
			return
		else:
			ChangeState("Ball")
			return
	
	if owner.velocity.y < 0.0:
		ChangeState("Fall")
		return
	
	var newVel : Vector3 = owner.velocity
	
	var inputVel : Vector3 = owner.GetInputVector(owner.up_direction)
	
	newVel += inputVel * owner.PARAMETERS.AIR_INPUT_VEL * _delta
	
	newVel = ApplyDrag(newVel, _delta)
	newVel = owner.ApplyGravity(newVel, _delta)
	
	
	owner.SetVelocity(newVel)
