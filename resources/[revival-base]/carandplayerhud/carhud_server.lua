RegisterServerEvent('police:setServerMeta')
AddEventHandler('police:setServerMeta', function(health, armor, thrist, hungry)
    local src = source
    local user = exports['revival-base']:GetCharacter(src)
    local cid = user.cid
	
	if not user then 
		print(debug.stacktrace)
		return 
	end
	
	local q = [[UPDATE characters SET metaData = @meta WHERE cid = @cid;]]
	local v = {
		["meta"] = json.encode({["health"] = health, ["armour"] = armor, ["thrist"] = thrist, ["hunger"] = hungry}),
		["cid"] = cid
	}

	if not user then return end
	exports.revival_database:execute(q, v, function()

    end)
end)

RegisterServerEvent("police:update:hud")
AddEventHandler("police:update:hud", function(health, armour, thirst, hunger)
    local src = source
    local user = exports['revival-base']:GetCharacter(src)
    local cid = user.cid
	if user ~= false then
		meta = { 
			["health"] = health,
			["armour"] = armour,
			["thirst"] = thirst,
			["hunger"] = hunger
		}

		local encode = json.encode(meta)
		exports.revival_database:execute('UPDATE characters SET metaData = ? WHERE cid = ?', {encode, cid})
	end
end)
