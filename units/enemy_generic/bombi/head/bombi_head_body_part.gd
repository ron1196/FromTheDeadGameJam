extends BodyPart

const ANIMATION_EXPLODE_NAME: String = "explode"

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite
@onready var self_destruct: SelfDestructTrait = %SelfDestruct


func activate_trait(unit: Unit, gtrait_idx: int) -> bool:
	var gtrait: GTrait = traits[gtrait_idx]

	match gtrait:
		self_destruct:
			animated_sprite.play(ANIMATION_EXPLODE_NAME)
			await animated_sprite.animation_finished
			self_destruct.activate(unit)
			return true

	return false
