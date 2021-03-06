--GLOCK-17 OPTION SCRIPT

local module = {

	--NON-MELEE WEAPONS
	AUTOMATIC = false,
	HITSCAN = true,
	
	BASE_DAMAGE = 15,
	HEADSHOT_MULTIPLIER = 3,
	
	FIRE_RATE = .166,
	MAGAZINE_SIZE = 20,
	TOTAL_AMMO = 120,
	RELOAD_TIME = 2,
	
	FIRE_SOUND_DISTANCE = 1000,
	BULLET_TRAVEL_SPEED = 750,
	BULLET_TRAVEL_LENGTH = 1000,
	
	MOVEMENT_INACCURACY = 1, --leave at 1 for no inacc
	JUMPING_INACCURACY = 1,
	COUNTER_STRAFE_INCREMENT = 1,
	
	FIRE_SWAY_SPEED = 7,
	FIRE_SWAY_X = 0.02,
	FIRE_SWAY_Y = 0.1,
	FIRE_SWAY_Z = 0.02,
	FIRE_RECOVERY_SWAY_X = 0.02,
	FIRE_RECOVERY_SWAY_Y = 0.05,
	FIRE_RECOVERY_SWAY_Z = 0.02,

	RELOAD_SWAY_X = 1,
	RELOAD_SWAY_Y = 1,
	RELOAD_SWAY_Z = 1,

	--MELEE WEAPONS
	SWINGSPEED = 1,
	SWING_SWAY = 1,
	
	--ALL WEAPONS
	MELEE = false,
	MASS = 7,

	WALK_SWAY = 1,
	PULLOUT_SWAY = 1,
	EQUIP_SWAY_SPEED = 4,
	EQUIP_SWAY_DOWN_DELAY = .1,
	
	SKINS = true,
	STATS = true,

}

return module
