RevivalCore = RevivalCore or {}

RegisterCommand('todo', function(source, args) 
	local rank = RevivalCore["Characters"]["rank"];
	print(RevivalCore["GetCitizenId"](source))
	if rank == "user" or rank == "admin" then return end;
	TriggerClientEvent("notification", source, "[1] set locations at interaction for weed store at the beach \n[2] LSD CUSTOM EFFCT(with animals with u and smoke and do funny things) \n[3] search for : todo test\n[4] polyzone for inventory drops.\n[5] do that u will can keep food at apartments and use laptop and shit.\n[6] delete commands", 2)
end)


local toggled = false

RegisterCommand('ooc', function(source, args)
    if not args[1] then return end
    local src = source
    local msg = ""
    for i = 1, #args do
      msg = msg .. " " .. args[i]
    end
    local _char = exports["revival-base"]:GetCharacter(source)
    local name = _char.name
    if not toggled then
        TriggerClientEvent('chatMessage', -1, 'OOC '.. name .. ' ['.. src .. '] ', 2, msg, "OOC")
    elseif toggled then
        TriggerClientEvent("notification", src, "OOC is disabled", 2)
    end
end)

RegisterCommand('pchat', function(source, args)
    if not args[1] then return end
    local src = source
    local msg = ""
    for i = 1, #args do
      msg = msg .. " " .. args[i]
    end
    local Player = exports["revival-base"]:GetCharacter(src)
    if Player and (Player:job().name == 'police') then
        TriggerClientEvent('chatMessage', source, 'Police | '.. Player.fullname ..' (' .. Player:job().callsign .. ')', 4, msg, "Police")
    end
end)

RegisterCommand("clear", function(source)
    TriggerClientEvent("chat:clear", source)
end)

RegisterCommand("clearall", function(source)
    local _char = exports["revival-base"]:GetCharacter(source)
    local rank = _char.rank
    if rank ~= "user" then
        TriggerClientEvent("chat:clear", -1)
    end
end)


RegisterCommand("toggle", function(source, args)
    local pSrc = source
    local command = string.lower(args[1])
    local _char = exports["revival-base"]:GetCharacter(pSrc)
    local rank = _char.rank
    if rank ~= "user" then
        if command == "ooc" then
            toggled = not toggled
            TriggerClientEvent("notification", pSrc, ('OOC has been %s!'):format(toggled and 'Disabled' or 'Enabled')) -- Pkarti was here
        end
    else
        print("Cant.")
    end
end)



RegisterCommand('id', function(source, args, user)
	TriggerClientEvent('notification', source, 'ID: '..source)
end)

RegisterCommand('rank', function(source, args, raw)
	TriggerClientEvent('notification', source, 'Rank : ' .. RevivalCore.Characters[source].rank ..'.')
end)

RegisterCommand('job', function(source, args)
	local _char = RevivalCore.Characters[source]
	TriggerClientEvent('notification', source, 'Job : ' .. _char:job()['label']..'.')
end)

RegisterCommand('job2', function(source, args)
	local _char = RevivalCore.Characters[source]
	TriggerClientEvent('notification', source, 'Secondary Job: '.._char:secondaryJob()["label"])
end)

RegisterCommand('gang', function(source, args)
	local _char = RevivalCore.Characters[source]
	TriggerClientEvent('notification', source, 'Gang : ' .. _char:gang()..'.')
end)

------------ Admin Commands ------------
RevivalCore.AddAdminCommand('sv', 'admin', function(source, args, user)
	RevivalCore.SpawnVehicle(source, args[1])
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
	AddLog(source, 'Spawned:car', RevivalCore.Characters[source].name..' Tried to spawn a vehicle('..vehicle..')')
end, {help = "Spawn Vehicle", arguments = {{name = "model", help = "Model Of The Vehicle"}}})

RevivalCore.AddAdminCommand('clearinv', 'admin', function(source, args, raw)
	local id = args[1]
	if not id then id = source end
	if id then
		RevivalCore.Characters[tonumber(id)].clearInventory()
		TriggerClientEvent('notification', id, "your inventory was deleted")
	else
		TriggerClientEvent('notification', source, "Invalid Id")
	end
end, function(source, args, raw)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "clears all inventory", arguments = {{name = "ID", help = "Player ID"}}})

RevivalCore.AddAdminCommand('dv', 'admin', function(source, args, user)
	RevivalCore.DeleteVehicle(source)
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Delete Vehicles"})

RevivalCore.AddAdminCommand("tpm", 'admin', function(source, args)
	if RevivalCore.Characters[source].rank ~= "user" then
		TriggerClientEvent('revival-base:tpm', source)
	else
		TriggerClientEvent("notification", source, "nice try):")
	end
end, function(source, args)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Teleport To Waypoint"})

RevivalCore.AddAdminCommand("tp", 'admin', function(source, args)
	if (args[1] ~= nil and (args[2] == nil and args[3] == nil)) then
		local Player = RevivalCore.Characters[tonumber(args[1])]
		if Player ~= nil then
			TriggerClientEvent('revival-base:GoToPlayer', source, Player.source)
		else
			TriggerClientEvent('notification', source, "Player is not online!", 2)
		end
	else
		if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
			local x = tonumber(args[1])
			local y = tonumber(args[2])
			local z = tonumber(args[3])
			TriggerClientEvent('revival-base:GoToCoords', source, x, y, z)
		else
			TriggerClientEvent('notification', source, "invalid x, y, z", 2)
		end
	end
end, function(source, args)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Teleport To Player / x,y,z"})

RevivalCore.AddAdminCommand('revive', 'admin', function(source, args)
	TriggerClientEvent("revival-death:revive", source)
end, function(source, args)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Revive Yourself"})

RevivalCore.AddAdminCommand('revivep', 'admin', function(source, args)
	local s = args[1]
	if s == nil then TriggerClientEvent('notification', source, "No ID...",2) end
	TriggerClientEvent("revival-death:revive", s)
end, function(source, args)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Revive Player"})

RevivalCore.AddAdminCommand('heal', 'admin', function(source, args)
	TriggerEvent('ems:healplayer', source, args[1])
end, function(source, args)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Heal Yourself"})

RevivalCore.AddAdminCommand('setcash', 'admin', function(source, args, user)
	local user = tonumber(args[1])
	local amount = tonumber(args[2])
	local _char = RevivalCore.Characters[user]

	if user and amount then
		if _char then
			_char.setMoney(amount, 'cash')
		else
			TriggerClientEvent('notification', source, 'Player not online')
		end
	end
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Set Cash", arguments = {{name = "ID", help = "Player ID"}, {name = "amount", help = "Cash Amount"}}})

RevivalCore.AddAdminCommand('givecash', 'admin', function(source, args, user)
	local user 	= tonumber(args[1])
	local amount = tonumber(args[2])
	local _char = RevivalCore.Characters[user]

	if user and amount then
		if _char then
			_char.giveMoney(amount, 'cash')
		else
			TriggerClientEvent('notification', source, 'Player not online')
		end
	end
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Give Cash", arguments = {{name = "ID", help = "Player ID"}, {name = "amount", help = "Cash Amount"}}})

RevivalCore.AddAdminCommand('setbank', 'admin', function(source, args, user)
	local user 	= tonumber(args[1])
	local amount = tonumber(args[2])
	local _char = RevivalCore.Characters[user]

	if user and amount > -1 then
		if Player then
			_char.setMoney(amount, 'bank')
		else
			TriggerClientEvent('notification', source, 'Player not online')
		end
	end
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Set Bank", arguments = {{name = "ID", help = "Player ID"}, {name = "amount", help = "Money Amount"}}})

RevivalCore.AddAdminCommand('givebank', 'admin', function(source, args, user)
	local user 	= tonumber(args[1])
	local amount = tonumber(args[2])
	local _char = RevivalCore.Characters[user]

	if user and amount > -1 then
		if _char then
			_char.giveMoney(amount, 'bank')
		else
			TriggerClientEvent('notification', source, 'Player not online')
		end
	end
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Give Cash", arguments = {{name = "ID", help = "Player ID"}, {name = "amount", help = "Cash Amount"}}})

RevivalCore.AddAdminCommand('setrank', 'developer', function(source, args, user)
	local target		= tonumber(args[1])
	local rank = tostring(args[2])
	local player = RevivalCore.Characters[target]
	if target ~= nil then
		if player then
			if RevivalFramework.Ranks[rank] then
				player.setRank(rank)
				TriggerClientEvent('notification', target, 'your rank was updated to: '..RevivalFramework.Ranks[rank].label)
			else
				TriggerClientEvent('notification', source, rank..' is not a valid rank')
			end
		end
	end
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Sets Rank", arguments = {{name = "ID", help = "Player ID"}, {name = "rank", help = "Rank"}}})

RevivalCore.AddAdminCommand('setjob', 'admin', function(source, args, user)
	local id = tonumber(args[1])
	local job = tostring(args[2])
	local grade1 = tonumber(args[3])
	local player = RevivalCore.Characters[id]
	if id ~= nil then
		if player then
			if RevivalFramework.Jobs[job] then
				if RevivalFramework.Jobs[job].grades[grade1] then
					player.setJob(job, grade1)
					TriggerClientEvent('notification', id, 'Your Job has been set to: '..RevivalFramework.Jobs[job].Job..'('..RevivalFramework.Jobs[job].grades[grade1].grade..')')
				else
					TriggerClientEvent('notification', source, 'Invaild Grade (' .. grade1 .. ')')
				end
			else
				TriggerClientEvent('notification', source, 'Invaild Job (' .. job .. ')')
			end
		else
			TriggerClientEvent('notification', source, 'Invaild ID (' .. id .. ')')
		end
	end
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Sets Job", arguments = {{name = "ID", help = "Player ID"}, {name = "job", help = "Job Name"}}})

RevivalCore.AddAdminCommand('setgang', 'admin', function(source, args, user)
	local id = tonumber(args[1])
	local gang = tostring(args[2])
	local player = RevivalCore.Characters[id]
	if id ~= nil then
		if player then
			if Gangs.Ranks[gang] then
				player.setGang(gang)
				TriggerClientEvent('notification', id, 'your gang was updated to: '..Gangs.Ranks[gang].label)
			else
				TriggerClientEvent('notification', source, 'Invaild Gang (' .. gang .. ')')
			end
		else
			TriggerClientEvent('notification', source, 'Invaild ID (' .. id .. ')')
		end
	end
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Sets Gang", arguments = {{name = "ID", help = "Player ID"}, {name = "gang", help = "Gang Name"}}})

RevivalCore.AddAdminCommand('setjob2', 'admin', function(source, args, user)
	local id = tonumber(args[1])
	local Job = tostring(args[2])
	local player = RevivalCore.Characters[id]
	if id ~= nil then
		if player then
			if SecondaryJob.Ranks[Job] then
				player.setSecondaryJob(Job)
				TriggerClientEvent('notification', id, 'your secondary job was updated to: '..SecondaryJob.Ranks[Job].label)
			else
				TriggerClientEvent('notification', source, 'Invaild Job (' .. Job .. ')')
			end
		else
			TriggerClientEvent('notification', source, 'Invaild ID (' .. id .. ')')
		end
	end
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Sets Secondary Job", arguments = {{name = "ID", help = "Player ID"}, {name = "Job", help = "Job Name"}}})

RevivalCore.AddAdminCommand('setlife', 'admin', function(source, args, user)
	local id = tonumber(args[1])
	local lifeStyle = tostring(args[2])
	local player = RevivalCore.Characters[id]
	if id ~= nil then
		if player then
			if LifeStyle["s"][lifeStyle] then
				player.setLifeStyle(lifeStyle)
				TriggerClientEvent('notification', id, 'your  life style was updated to: '..LifeStyle["s"][lifeStyle]["label"])
			else
				TriggerClientEvent('notification', source, 'Invaild Life Style (' .. lifeStyle .. ')')
			end
		else
			TriggerClientEvent('notification', source, 'Invaild ID (' .. id .. ')')
		end
	end
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Sets Secondary Job", arguments = {{name = "ID", help = "Player ID"}, {name = "Job", help = "Job Name"}}})

RevivalCore.AddAdminCommand('giveitem', 'admin', function(source, args, user)
    local _char = RevivalCore.Characters[tonumber(args[1])]
    local item    = args[2]
    local count   = (args[3] == nil and 1 or tonumber(args[3]))
    if count ~= nil then
        if _char ~= nil then
            TriggerClientEvent('player:receiveItem', _char.source, ""..item.."", count)
        else
			TriggerClientEvent('notification', source, 'Invaild ID (' .. args[1] .. ')',2)
        end
    end
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Give Item", arguments = {{name = "ID", help = "Player ID"}, {name = "Item", help = "Item"}, {name = "Amount", help = "Amount"}}})

RevivalCore.AddAdminCommand('nc', 'admin', function(source)
	TriggerClientEvent('revival-base:noclip', source)
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "NoClip"})

RevivalCore.AddAdminCommand('ban', 'admin', function(source, args, user)
	local id = args[1]
	local reason = args[2]
	if not id or not reason then
		reason = "i be gucci'd down, you wearing lacoste and shit (bitch yeah)\nPerma Banned | Reason: wearing lacoste"
		TriggerClientEvent('notification', source, "/ban [playerId] [reason]")
	else
		local name = GetPlayerName(id)
		local adminName = GetPlayerName(source)
		local LogInfo = name.." Got Ban By "..adminName.."\nReason: "..reason
		RevivalCore.BanPlayer(id, reason)
		DiscordLog("https://discord.com/api/webhooks/894135153151078429/F7-qUbtowWnJuDdsfGjj9-WiUaR0bZtb4nXzYNz_ylvmodxUvAY9CkzaPBEyrlx-f7HC", pSrc, name.." Got Ban", reason, LogInfo)
	end
end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Ban", arguments = {{name = "PlayerId", help = "Player ID"}, {name = "Reason", help = "Reason Of The Ban"}}})

RevivalCore.AddAdminCommand('kick', 'admin', function(source, args, user)
	local id = args[1]
	local reason = args[2]
	if not id or not reason then
		reason = "i be gucci'd down, you wearing lacoste and shit (bitch yeah)\n You Kicked Out From The Server| Reason: wearing lacoste"
		TriggerClientEvent('notification', source, "/kick [playerId] [reason]")
	else
		local name = GetPlayerName(id)
		local adminName = GetPlayerName(source)
		local LogInfo = name.." Got Kick By "..adminName.."\nReason: "..reason
		RevivalCore.KickPlayer(id, reason)
		DiscordLog("https://discord.com/api/webhooks/894135153151078429/F7-qUbtowWnJuDdsfGjj9-WiUaR0bZtb4nXzYNz_ylvmodxUvAY9CkzaPBEyrlx-f7HC", pSrc, name.." Got Kick", "", LogInfo)
	end

end, function(source, args, user)
	TriggerClientEvent('notification', source, "Nice Try(:",2)
end, {help = "Kick", arguments = {{name = "PlayerId", help = "Player ID"}, {name = "Reason", help = "Reason Of The Kick"}}})

RegisterCommand('players', function(source)
	TriggerClientEvent('notification', source, "Online Players: "..GetNumPlayerIndices())
end)