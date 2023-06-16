RegisterServerEvent('sendSessionPlayerNumber')
AddEventHandler('sendSessionPlayerNumber', function(clientPlayerNumber, name, id)
	serverPlayerNumber = countPlayer()
	if(clientPlayerNumber < serverPlayerNumber) then
		if(clientPlayerNumber == 1) then -- if player are solo
			local reason = 'Auto-Kick' -- reason of kick (solo session detected)
			local msg = name .. " KICKED, SERVER SEE: " .. serverPlayerNumber .. " PLAYERS, CLIENT SEE: " .. clientPlayerNumber -- console message (example : client see 1/24 players , server see 24/24 players)
			RconPrint('AUTOKICK: ' .. msg .. "\n") -- console title message (AUTOKICK : console message)
			
			DropPlayer(id, reason) -- kick player
		end
	end
end)

function countPlayer() -- count all players
	Count = 0
	for _ in pairs(GetPlayers()) do
		Count = Count + 1
	end
	return Count
end