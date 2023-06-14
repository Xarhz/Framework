RevivalCore = RevivalCore or {}

RevivalCore.RegisterServerCallback = function(name, cb)
	RevivalCore.ServerCallbacks[name] = cb
end

RevivalCore.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if RevivalCore.ServerCallbacks[name] ~= nil then
		RevivalCore.ServerCallbacks[name](source, cb, ...)
	else
		print('TriggerServerCallback => [' .. name .. '] does not exist')
	end
end

RevivalCore.Math = function(value, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

RevivalCore.CountTable = function(tbl)
    local count = 0
        for k, v in pairs(tbl) do
        count = count + 1
        end
    return count
end


RevivalCore.CharacterLogin = function(source, pData, isNew)
	local src 			= source
	local identifier 	= pData.identifier
	local cid 			= pData.cid
	--local name 			= pData.name
	exports['revival_database']:execute('SELECT * FROM characters WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid}, function(characterInformation)
		_char = SetCharacterData(src, cid, characterInformation[1])
		RevivalCore.Characters[src] = _char
		_char["TriggerEvent"]('revival-base:characterData', {
			identifier = _char.identifier,
			cid = _char.cid,
			source = _char.source,
			name = _char.name,
			firstname = _char.firstname,
			lastname = _char.lastname,
			cash = _char.cash,
			bank = _char.bank,
			job = _char.job(),
			secondaryJob = _char.secondaryJob(),
			ymstyle = _char.LifeStyle(),
			gang = _char.gang(),
			needs = _char.needs(),
			rank = _char.rank,
			dob = _char.dob,
			lastPosition = json.decode(_char.position),
			sex = _char.sex,
			phone = _char.phone,
			citizenid = _char.citizenid,
			bankAccount = _char.bankAccount,
			jail = _char.jail,
			fullname = _char.firstname..' '.._char.lastname,
		})
		if isNew then
			print('[^2RevivalCore^0] '.._char.name..', CID: '..cid..' was created successfully!')
		else
			print('[^2RevivalCore^0] '.._char.name..', CID: '..cid..' was loaded successfully!')
			if (_char["jail"] > 0) then
				TriggerClientEvent("spawnselector", _char["source"], false, true)
			else
				TriggerClientEvent("spawnselector", _char["source"], true, false)
			end
			TriggerClientEvent("revival-base:initialPlayer", src)
		end
		TriggerClientEvent('revival-base:characterSpawned', src)
		TriggerClientEvent('revival-base:blips:start', src)
		TriggerClientEvent('rich:playerLoggedIn', src)
		TriggerEvent("request-dropped-items")
		TriggerEvent("server-request-update", _char["citizenid"])
	end)
end

RevivalCore.GetCharacter = function(source)
	if RevivalCore.Characters[source] ~= nil then
		return RevivalCore.Characters[source]
	end
	print("^4"..GetPlayerName(source).." - nil character^7")
	return nil
end

RevivalCore.GetCharacters = function()
	local players = {}
	for k, v in pairs(RevivalCore.Characters) do
		table.insert(players, k)
		-- players[#players + 1] = k
	end
	return players
end

RevivalCore.clearInventory = function(id)
	TriggerEvent('revival-inventory:delete', id)
end

RevivalCore.DeleteCharacter = function(id, cid, src)
	local citizenid = string.sub(id..cid ,14)
	local dickhead = {
		{db = "characters", fuck = "identifier"},
		{db = "character_current", fuck = "id"},
		{db = "character_face", fuck = "id"},
		{db = "character_outfits", fuck = "id"},
		{db = "character_tattoos", fuck = "identifier"},
		{db = "character_vehicles", fuck = "owner"},
		{db = "character_licenses", fuck = "owner"},
		{db = "weapon_ammo", fuck = "identifier"},
	}	
	for _, table in pairs(dickhead) do
		local values = {
			["id"] = id,
			["cid"] = cid,
		}
		local data =  RevivalCore["SQL"]["execute"]("DELETE FROM "..table["db"].." WHERE "..table["fuck"].." = @id AND cid = @cid",values)
		if data then
			print("[revival-base] Character Deleted ["..id.."]")
		end
	end
	RevivalCore["SQL"]["execute"]("DELETE FROM weapon_serials WHERE owner = @id",{["id"] = RevivalCore.Characters[src]["fullname"]})
	RevivalCore["SQL"]["execute"]("DELETE FROM phone_contacts WHERE identifier = @id",{["id"] = citizenid})
	TriggerEvent('apartment:delete', citizenid)
	RevivalCore.clearInventory(id)
end

RevivalCore.SpawnVehicle = function(source, vehicle)
	AddLog(source, 'Spawned:car', RevivalCore.Characters[source].name..' Spawn Vehicle('..vehicle..')')
	TriggerClientEvent('revival-base:SpawnVehicle', source, vehicle)
end

RevivalCore.DeleteVehicle = function(source)
	TriggerClientEvent('revival-base:DeleteVehicle', source)
end

RevivalCore.doesCharacterExist = function(identifier, callback)
	TriggerEvent('revival-base:doesCharacterExist', identifier, callback)
end



RevivalCore.setRank = function(player, rank)
	local src = player
	local identifier = RevivalCore.Characters[src].identifier
	local pCid = RevivalCore.Characters[src].cid
	if DBFramework.Ranks[rank] then
		exports['revival_database']:execute('UPDATE characters SET rank = @rank WHERE identifier = @identifier AND cid = @cid', {
			['@identifier'] = identifier,
			['@cid'] = pCid,
			['@rank'] = rank
		})
		TriggerClientEvent('revival-base:updateRank', src, rank)
	else
		TriggerClientEvent('notification', src, rank..' rank not exist.')
	end
end

RevivalCore.addCash = function(player, amount)
	local identifier = player.identifier
	local pCid = player.cid
	local total = player.cash + amount
	exports['revival_database']:execute('UPDATE characters SET cash = @cash WHERE identifier = @identifier AND cid = @cid', {
		['@identifier'] = identifier, 
		['@cash'] = total,
		['@cid'] = pCid
	})
	TriggerClientEvent('revival-base:updateCash', player.source, total)	
end

RevivalCore.removeCash = function(player, amount)
	local identifier = player.identifier
	local pCid = player.cid
	if player.cash - amount < 0 then return end
	exports['revival_database']:execute('UPDATE characters SET cash = @cash WHERE identifier = @identifier AND cid = @cid', {
		['@identifier'] = identifier, 
		['@cid'] = pCid,
		['@cash'] = player.cash - amount
	})
	TriggerClientEvent('revival-base:updateCash', player.source, player.cash - amount)
end

RevivalCore.setCash = function(player, amount)
	local identifier = player.identifier
	local pCid = player.cid
	if (amount > 0) then
		exports['revival_database']:execute('UPDATE characters SET cash = @cash WHERE identifier = @identifier AND cid = @cid', {
			['@identifier'] = identifier,
			['@cash'] = amount,
			['@cid'] = pCid
		})

		TriggerClientEvent('notification', source, 'Your cash has been set to: $'..amount)
		TriggerClientEvent('revival-base:updateCash', player.source, amount)
	else
		TriggerClientEvent('notification', player.source, 'Try Again',2)
	end
end

RevivalCore.giveCash = function(player, amount)
	local identifier = player.identifier
	local pCid = player.cid
	if (amount > 0) then
		local total = player.cash + amount
		exports['revival_database']:execute('UPDATE characters SET cash = @cash WHERE identifier = @identifier AND cid = @cid', {
			['@identifier'] = identifier,
			['@cash'] = total,
			['@cid'] = pCid
		})
		TriggerClientEvent('notification', source,  'There is: $'..amount..' added to your cash')
		TriggerClientEvent('revival-base:updateCash', player.source, total)
	end
end

-- BANK

RevivalCore.addBank = function(player, amount)
	local identifier = player.identifier
	local pCid = player.cid
	if (amount > 0) then
		local add = player.bank + amount
		exports['revival_database']:execute('UPDATE characters SET bank = @bank WHERE identifier = @identifier AND cid = @cid', {
			['@identifier'] = identifier, 
			['@bank'] = add,
			['@cid'] = pCid
		})
		--need to add notification
		TriggerClientEvent('revival-base:updateBank', player.source, add)
	end
end

RevivalCore.removeBank = function(player, amount)
	local identifier = player.identifier
	local pCid = player.cid
	if player.bank - amount < 0 then return end
	local add = player.bank - amount
	exports['revival_database']:execute('UPDATE characters SET bank = @bank WHERE identifier = @identifier AND cid = @cid', {
		['@identifier'] = identifier, 
		['@bank'] = add,
		['@cid'] = pCid
	})
	--need to add notification
	TriggerClientEvent('revival-base:updateBank', player.source, add)
end

RevivalCore.setBank = function(player, amount)
	local identifier = player.identifier
	local pCid = player.cid
	if (amount > 0) then
		exports['revival_database']:execute('UPDATE characters SET bank = @bank WHERE identifier = @identifier AND cid = @cid', {
			['@identifier'] = identifier,
			['@bank'] = amount,
			['@cid'] = pCid
		})
		--need to change to notification
		TriggerClientEvent('notification', source, 'Your bank balance has been set to: ^*$'..amount)
		TriggerClientEvent('revival-base:updateBank', player.source, amount)
	else
		TriggerClientEvent('notification', player.source, 'Try Again',2)
	end
end

RevivalCore.giveBank = function(player, amount)
	local identifier = player.identifier
	local pCid = player.cid
	if (amount > 0) then
		local total = player.bank + amount
		exports['revival_database']:execute('UPDATE characters SET bank = @bank WHERE identifier = @identifier AND cid = @cid', {
			['@identifier'] = identifier,
			['@bank'] = total,
			['@cid'] = pCid
		})
		--need to change to notification
		TriggerClientEvent('notification', source, 'There is: ^*$'..amount..'^r added to your bank balance')
		TriggerClientEvent('revival-base:updateBank', player.source, total)
	end
end

RevivalCore.AddCommand = function(command, callback, suggestion, arguments)
	RevivalCore.Commands[command] = {}
	RevivalCore.Commands[command].cmd = callback
	RevivalCore.Commands[command].arguments = arguments or -1

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		RevivalCore.CommandsSuggestions[command] = suggestion
	end

	RegisterCommand(command, function(source, args)
		if((#args <= RevivalCore.Commands[command].arguments and #args == RevivalCore.Commands[command].arguments) or RevivalCore.Commands[command].arguments == -1)then
			callback(source, args, RevivalCore.Characters[source])
		end
	end, false)
end

RevivalCore.AddAdminCommand = function(command, rank, callback, callbackfailed, suggestion, arguments)
	RevivalCore.Commands[command] = {}
	RevivalCore.Commands[command].perm = math.maxinteger
	RevivalCore.Commands[command].rank = rank
	RevivalCore.Commands[command].cmd = callback
	RevivalCore.Commands[command].callbackfailed = callbackfailed
	RevivalCore.Commands[command].arguments = arguments or -1

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		RevivalCore.CommandsSuggestions[command] = suggestion
	end

	--ExecuteCommand('add_ace group.' .. rank .. ' command.' .. command .. ' allow')

	RegisterCommand(command, function(source, args)
		local Source = source
		local pData = RevivalCore.Characters[Source]

		if(source ~= 0)then
			if pData ~= nil then
				if RevivalCore.HasPerms(source, RevivalCore.Commands[command].rank) then
					if((#args <= RevivalCore.Commands[command].arguments and #args == RevivalCore.Commands[command].arguments) or RevivalCore.Commands[command].arguments == -1)then
						callback(source, args, RevivalCore.Characters[source])
					end
				--else
					--TriggerClientEvent('notification', source, 'bruh, learn how to use',2)
				end
			end
		else
			if((#args <= RevivalCore.Commands[command].arguments and #args == RevivalCore.Commands[command].arguments) or RevivalCore.Commands[command].arguments == -1)then
				callback(source, args, RevivalCore.Characters[source])
			end
		end
	end)
end

RevivalCore.HasPerms = function(source, r)
	local _char = RevivalCore.Characters[source]
	if _char.rank == r or DBFramework.Ranks[_char.rank].rank > DBFramework.Ranks[r].rank then
		return true
	end
	return false
end

exports('AddAdminCommand', function(command, rank, callback, callbackfailed, suggestion, arguments)
	RevivalCore.AddAdminCommand(command, rank, callback, callbackfailed, suggestion, arguments)
end)

exports('AddCommand', function(command, callback, suggestion, arguments)
	RevivalCore.AddCommand(command, callback, suggestion, arguments)
end)

exports('GetCharacter', function(source)
	if RevivalCore.Characters[source] ~= nil then
		return RevivalCore.Characters[source]
	end
	return nil
end)

exports('GetCharacterByCitizenId', function(citizenid)
	for src, player in pairs(RevivalCore.Characters) do
		if RevivalCore.Characters[src].citizenid == citizenid then
			return RevivalCore.Characters[src]
		end
	end
	return nil
end)

exports('GetCharacterByPhone', function(num)
	for src, player in pairs(RevivalCore.Characters) do
		if RevivalCore.Characters[src].phone == num then
			return RevivalCore.Characters[src]
		end
	end
	return nil
end)

exports('GetCharacterByBankAccount', function(bankId)
	for src, player in pairs(RevivalCore.Characters) do
		if RevivalCore.Characters[src].bankAccount == bankId then
			return RevivalCore.Characters[src]
		end
	end
	return nil
end)


exports('GetCharacters', function()
	local players = {}
	for k, v in pairs(RevivalCore.Characters) do
		table.insert(players, k)
	end
	return players
end)

exports('clearInventory', function(source, id)
	RevivalCore.clearInventory(id)
end)

exports('SpawnVehicle', function(source, vehicle)
	RevivalCore.SpawnVehicle(source, vehicle)
end)

exports('deleteVehicle', function(source)
	RevivalCore.DeleteVehicle(source)
end)

exports('doesCharacterExist', function(identifier, callback)
	RevivalCore.doesCharacterExist(identifier, callback)
end)

exports('setRank', function(source, rank)
	RevivalCore.setRank(source, rank)
end)

exports('RegisterCallBack', function(name, cb)
	RevivalCore.ServerCallbacks[name] = cb
end)