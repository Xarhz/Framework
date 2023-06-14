RevivalCore = RevivalCore or {}

RegisterServerEvent('revival-base:updateLocation')
AddEventHandler('revival-base:updateLocation', function(lastPosition)
    RevivalCore.lastPosition[source] = {x = lastPosition["x"], y = lastPosition["y"], z = lastPosition["z"]}
end)

RegisterServerEvent('revival-base:banPlayer')
AddEventHandler('revival-base:banPlayer', function(id, reason)
	RevivalCore.BanPlayer(id, reason)
end)

local onduty = false

RegisterServerEvent('revival-base:toggleDuty')
AddEventHandler('revival-base:toggleDuty', function()
    local src = source
    local _char = RevivalCore.Characters[src]
    onduty = not onduty
    if (onduty) then
        _char.setDuty(true)
    else
        _char.setDuty(false)
    end
end)

AddEventHandler('playerDropped', function(reason)
	local player = RevivalCore.Characters[source]
	if player then
		-- TriggerClientEvent("hud:save", source)
		local meta = { 
            thirst = player:needs().thirst;
            hunger = player:needs().hunger;
        }
		SaveCharacter(source, player.identifier, player.cid, RevivalCore.lastPosition[source], meta)
		pLogData = player.name .. "("..player.citizenid..") exited | reason: " .. reason
		AddLog(source, "player-left", pLogData)	
		RevivalCore.Characters[source] = nil
	end
end)

AddEventHandler('revival-base:doesCharacterExist', function(identifier, callback)
	exports['revival_database']:execute('SELECT * FROM characters WHERE identifier = @identifier', {['@identifier'] = identifier}, function(users)
		if users[1] then
			callback(true)
		else
			callback(false)
		end
	end)
end)


RegisterServerEvent('revival-base:refreshPlayer')
AddEventHandler('revival-base:refreshPlayer', function(pData)
	local src = source
	RevivalCore.CharacterLogin(src, pData, false)
end)

RegisterServerEvent('revival-base:triggerServerCallback')
AddEventHandler('revival-base:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	RevivalCore.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('revival-base:serverCallback', _source, requestId, ...)
	end, ...)
end)

AddEventHandler('revival-base:AddCommand', function(command, callback, suggestion, arguments)
	RevivalCore.AddCommand(command, callback, suggestion, arguments)
end)

AddEventHandler('revival-base:AddAdminCommand', function(command, rank, callback, callbackfailed, suggestion, arguments)
	RevivalCore.AddAdminCommand(command, group, callback, callbackfailed, suggestion, arguments)
end)

RegisterServerEvent('revival-base:givepayment')
AddEventHandler('revival-base:givepayment', function()
	local src = source
	if src then
		local _char = RevivalCore.Characters[src]
		if _char ~= nil then
			local amount = _char:job().payment
			if _char then
				if DBFramework.Jobs[_char:job().name] ~= nil then
					_char.addMoney(amount, 'bank')
					TriggerClientEvent('notification', src, 'You Get Your Payment : ' .. amount .. '$.',3)
				end
			end
		else
			TriggerClientEvent('notification', src, 'You not got your payment[nil].',2)
		end
	end
end)