require "/scripts/slimepersonglobalfunctions.lua"
function init()
  getSkinColorOnce=0
  script.setUpdateDelta(1)
end

function update(dt)
 -- animator.setFlipped(mcontroller.facingDirection() == -1)
	if getSkinColorOnce == 0 then
		getSkinColorOnce=1
		local result = world.entityPortrait(entity.id(),"full")
		local myRace = world.entitySpecies(entity.id())
		if myRace ~= "slimeperson" then
			animator.setLightColor("xelglow", {85,0,255})
		else
			local i = 1
			local done = 0
			while i < 12 do
					if string.find(sb.printJson(result[i].image), "head") ~= nil then
						local bodyColor = sb.printJson(result[i].image)
						bodyColor = bodyColor:sub(2,-2)
						local splited = bodyColor:split("?")
						animator.setGlobalTag("skinColor", "?" .. splited[2])
						local startIndex = string.find(splited[2], "478844=")
						--sb.logInfo("%s", splited[2]:sub(startIndex + 7,startIndex + 12))
						local hexcode = "#" .. splited[2]:sub(startIndex + 7,startIndex + 12)
						hexcode = hex2rgb(hexcode)
						local rgbValues = hexcode:split(",")
						--sb.logInfo("%s",rgbValues[1] ..",".. rgbValues[2]..","..rgbValues[3])
						animator.setLightColor("xelglow", {rgbValues[1],rgbValues[2],rgbValues[3]})
						i = 13
					end
				i = i + 1
			end
		end
	end
	script.setUpdateDelta(0)
end

function uninit()
   getSkinColorOnce=0
end