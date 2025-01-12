extends "res://entities/Player/MoveAir.gd"


var SetInvincible := false
var LeftGround := false


const HURT_INITIAL_UP_SPEED = 5.0
const HURT_DROPPED_RING_COUNT = 20
const HURT_DROPPED_RING_SPEED = 1.25

const RING = preload("res://entities/RingBounce/RingBounce.tscn")



func Enter(_msg := {}) -> void:
	owner.AnimTree.set("parameters/Hurt/blend_amount", 1.0)
	owner.AnimTree.set("parameters/OSHurt/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	owner.velocity = Vector3(0, HURT_INITIAL_UP_SPEED, 0)
	if _msg.has("BounceDirection"):
		owner.SetVelocity(_msg["BounceDirection"] + owner.velocity)
		owner.SetTrueVelocity(owner.velocity)
	
	if _msg.has("Bonk") and _msg["Bonk"]:
		owner.SndBonk.play()
	
	#failsafe
	owner.ActivateHitbox(false)
	
	owner.UpdateUpDir(Vector3(0, 1, 0), -1.0)
	owner.CharMesh.look_at(owner.global_position - (owner.velocity * Vector3(1, 0, 1)).normalized())
	
	LeftGround = !owner.GroundCollision
	owner.CanCollectRings = false
	owner.StickToFloor = false
	
	
	if _msg.has("DropRings") and _msg["DropRings"]:
		var DroppedRings = HURT_DROPPED_RING_COUNT
		if Globals.RingCount - HURT_DROPPED_RING_COUNT < 0:
			DroppedRings = Globals.RingCount
		
		for i in range(DroppedRings):
			var newRing = RING.instantiate()
			owner.get_parent().add_child(newRing)
			newRing.global_position = owner.global_position + Vector3(0, 0.25, 0)
			newRing.SetVelocity(Globals.DroppedRingSpeed)
		
		Globals.RingCount -= DroppedRings
		owner.SndRingDrop.play()
		
		SetInvincible = true
		owner.Invincible = true
		owner.ActivateHurtbox(false)
		
		Globals.DroppedRingSpeed += HURT_DROPPED_RING_SPEED


func Exit() -> void:
	owner.AnimTree.set("parameters/Hurt/blend_amount", 0.0)
	owner.AnimTree.set("parameters/OSHurt/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	
	owner.StickToFloor = true
	owner.CanCollectRings = true
	
	owner.SetFlicker(owner.Parameters.HURT_INVINCIBILITY_TIME)
	
	if SetInvincible:
		owner.ActivateHurtbox(true)
		owner.SetInvincible(owner.Parameters.HURT_INVINCIBILITY_TIME)
		SetInvincible = false
	else:
		owner.Invincible = false



func Update(_delta: float) -> void:
	owner.Move()
	
	var collision : CharCollision = owner.GetCollision()
	if CheckGroundCollision(collision):
		if LeftGround:
			ChangeState("Land", {
				"Flicker": 1.0,
			})
			return
		else:
			if owner.velocity.y < 0.0:
				LeftGround = true
		
	var newVel : Vector3 = owner.TrueVelocity
	
	newVel = owner.ApplyGravity(newVel, _delta)
	
	owner.SetTrueVelocity(newVel)
	owner.SetVelocity(newVel)
