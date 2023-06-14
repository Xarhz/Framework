RevivalCore = RevivalCore or {}

RevivalCore.KickPlayer = function(id, reason)
    if id and reason then
        DropPlayer(id, reason)
    end
end

RevivalCore.BanPlayer = function(id, reason)
    if id and reason then
        local user = RevivalCore.Characters[id]
        if user ~= nil then
            hexId = user.identifier
        else
            hexId = GetPlayerIdentifiers(id)[1]
        end
        local pName = GetPlayerName(id)
        exports.revival_database:execute('INSERT INTO character_bans (name, steam_id, ip, reason) VALUES (@steam_name, @steam_id, @ip, @reason)', {
            ['@steam_name'] = pName,
            ['@steam_id'] = hexId,
            ['@ip'] = GetPlayerIdentifiers(id)[2],
            ['@reason'] = reason
        }, function()
        end)
        Wait(250)
        DropPlayer(id, reason)
    end
end