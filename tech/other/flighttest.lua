require "/scripts/vec2.lua"

function init()
  self.energyCostPerSecond = config.getParameter("energyCostPerSecond")
  self.active=false
  self.available = true
  self.species = world.entitySpecies(entity.id())
end

function uninit()
  animator.setParticleEmitterActive("feathers", false)	
  animator.stopAllSounds("activate")
  effect.removeStatModifierGroup(foodPower)
end

function checkFood()
	if status.isResource("food") then
		self.foodValue = status.resource("food")		
	else
		self.foodValue = 15
	end
end

function activeFlight()
    if config.getParameter("removesFallDamage",0) == 1 then
	status.addEphemeralEffects{{effect = "nofalldamage", duration = 0.1}}
    end

    mcontroller.controlParameters(config.getParameter("fallingParameters"))
    mcontroller.setYVelocity(math.max(mcontroller.yVelocity(), config.getParameter("maxFallSpeed")))
    animateFlight()
end

function animateFlight()
    if self.species == "saturnian" then
    	animator.setParticleEmitterOffsetRegion("butterflies", mcontroller.boundBox())
    	animator.setParticleEmitterActive("butterflies", true)	    
    else
    	animator.setParticleEmitterOffsetRegion("feathers", mcontroller.boundBox())
    	animator.setParticleEmitterActive("feathers", true)	
    end
    animator.playSound("activate",2)
    animator.setFlipped(mcontroller.facingDirection() < 0)   
end

function update(args)
        checkFood()

	if args.moves["special1"] and not mcontroller.onGround() and not mcontroller.zeroG() and status.overConsumeResource("energy", 0.001) then 
		if self.foodValue > 15 then
		    status.addEphemeralEffects{{effect = "foodcost", duration = 0.1}}
		else
		    status.overConsumeResource("energy", config.getParameter("energyCostPerSecond"),1)
		end	
	    	activeFlight()
	else
  	    animator.setParticleEmitterActive("feathers", false)
  	    animator.setParticleEmitterActive("butterflies", false)
  	    animator.stopAllSounds("activate")	
	end
end

function idle()

end