extends BasicState




func Enter(_msg := {}) -> void:
	owner.AnimTree.active = true


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass
