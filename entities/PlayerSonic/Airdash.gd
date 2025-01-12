extends "res://entities/Player/MoveAir.gd"


const AIRDASH_FORWARD_SPEED = 25.0
const AIRDASH_DRAG_COEFF = 1.5
const AIRDASH_MIN_REQ_SPEED = 2.0


func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Movement/blend_amount", 1.0)
	owner.AnimTree.set("parameters/Air/blend_amount", 1.0)
	
	owner.SetAfterimageBody(false)
	owner.SetAfterimageLimbs(false)
	owner.AirdashTrail.Active = true
	
	owner.SndAirdash.play()
	$TimerAirdash.start()
	
	var newVel : Vector3 = owner.TrueVelocity
	
	#if the player is standing still, shoot forward
	if (newVel * Vector3(1, 0, 1)).length() <= 0.0:
		newVel = owner.CharMesh.GetForwardVector()
		
	
	newVel = newVel.normalized()
	#Clamp Y vel so the player can't just rocket straight up
	newVel.y = clamp(newVel.y, -0.9, 0.4)
	
	
	owner.SetTrueVelocity(newVel.normalized() * AIRDASH_FORWARD_SPEED)
	owner.SetVelocity(owner.TrueVelocity)

	owner.UpdateUpDir(Vector3.UP, -1.0)
	owner.CharMesh.AlignToY(Vector3.UP)
	owner.CharMesh.LookAt(owner.global_position + owner.velocity)


func Exit() -> void:
	owner.AirdashTrail.Active = false
	owner.SetAfterimageBody(owner.DashMode)
	owner.SetAfterimageLimbs(owner.DashMode)
	
	owner.SndAirdash.stop()
	$TimerAirdash.stop()


func Update(_delta: float) -> void:
	owner.Move()
	
	var collision : CharCollision = owner.GetCollision()
	if CheckGroundCollision(collision):
		#Landed
		return
	
	if collision.CollisionType == CharCollision.WALL:
		if collision.CollisionNormal.dot(owner.velocity.normalized()) < 0.25:
			#Bounce off wall
			owner.SndBonk.play()
			ChangeState("Hurt", {
				"BounceDirection": (collision.CollisionNormal * Vector3(1, 0, 1)).normalized(),
			})
			return

	var newVel = owner.TrueVelocity
	
	newVel = ApplyAirDrag(newVel, _delta)
	newVel = owner.ApplyGravity(newVel, _delta)
	
	owner.SetTrueVelocity(newVel)
	owner.SetVelocity(newVel)


func _on_timer_airdash_timeout() -> void:
	ChangeState("Fall")
