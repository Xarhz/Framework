RevivalCore = RevivalCore or {}
RegisterServerEvent('revival-multicharacters:GetCharacters', function()
    local src = source
    local steam = GetSteamID(src)
    if steam == "not found" then DropPlayer(src, "not steam") end
    local chars = RevivalCore["SQL"]["execute"]("select * from characters where identifier = @identifier", {["@identifier"] = steam})
    TriggerClientEvent('revival-multicharacters:setupCharacters', src, chars)
    SetPlayerRoutingBucket(src, src);
end)

RegisterServerEvent('revival-multicharacters:GetCharacter', function(cid)
    local src = source
    local steam = GetSteamID(src)
    local chars = RevivalCore["SQL"]["execute"]('SELECT * FROM characters WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = steam, ["@cid"] = cid})
    if chars then
        TriggerClientEvent('revival-multicharacters:GetCharacter', src, chars)
    else
        TriggerClientEvent('revival-multicharacters:GetCharacter', src, "Empty")
    end
end)

RegisterServerEvent('revival-base:SessionStarted', function()
    local src = source
    TriggerClientEvent('revival-base:SessionStarted', src)
end)

RegisterServerEvent('revival-multicharacters:charSelect', function(cid, isNew)
    local src = source
    local steam = GetSteamID(src)
	local PlayerData = {
		identifier = steam,
		cid = cid,
		name = GetPlayerName(src)
	}
	RevivalCore.CharacterLogin(src, PlayerData, isNew)
    SetPlayerRoutingBucket(src, 0)
end)

RegisterServerEvent('revival-multicharacters:deleteChar', function(cid)
    local src = source
    local identifier = GetSteamID(src)
    RevivalCore.DeleteCharacter(identifier, cid, src)
end)

RegisterServerEvent("revival-multicharacters:pedshit", function(cid)
    local src = source
    local char = {}
    exports['revival_database']:execute("SELECT * FROM `character_current` WHERE id = '"..GetPlayerIdentifiers(src)[1].."' AND cid = '" .. cid .. "'", {}, function(character_current)
        char.model = '1885233650'
        char.drawables = json.decode('{"1":["masks",0],"2":["hair",0],"3":["torsos",0],"4":["legs",0],"5":["bags",0],"6":["shoes",1],"7":["neck",0],"8":["undershirts",0],"9":["vest",0],"10":["decals",0],"11":["jackets",0],"0":["face",0]}')
        char.props = json.decode('{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",-1]}')
        char.drawtextures = json.decode('[["face",0],["masks",0],["hair",0],["torsos",0],["legs",0],["bags",0],["shoes",2],["neck",0],["undershirts",1],["vest",0],["decals",0],["jackets",11]]')
        char.proptextures = json.decode('[["hats",-1],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]]')

        if character_current[1] and character_current[1].model then
            char.model = character_current[1].model
            char.drawables = json.decode(character_current[1].drawables)
            char.props = json.decode(character_current[1].props)
            char.drawtextures = json.decode(character_current[1].drawtextures)
            char.proptextures = json.decode(character_current[1].proptextures)
        end

        exports['revival_database']:execute("SELECT * FROM `character_face` WHERE id = '"..GetPlayerIdentifiers(src)[1].."' AND cid = '" .. cid .. "'", {}, function(character_face)
            if character_face[1] and character_face[1].headBlend then
                char.headBlend = json.decode(character_face[1].headBlend)
                char.hairColor = json.decode(character_face[1].hairColor)
                char.headStructure = json.decode(character_face[1].headStructure)
                char.headOverlay = json.decode(character_face[1].headOverlay)
            end

            TriggerClientEvent("revival-multicharacters:getPed", src, char)
        end)
    end)
end)


RegisterServerEvent('revival-multicharacters:createCharacter')
AddEventHandler('revival-multicharacters:createCharacter', function(cData)
    local src = source
    local steam = GetSteamID(src)
    local meta = { 
        ["health"] = 100,
        ["armour"] = 100,
        ["thirst"] = 100,
        ["hunger"] = 100, 
    }
    local saveCharacter = RevivalCore["SQL"]["execute"]('INSERT INTO characters (`identifier`, `name`, `cid`, `citizenid`, `cash`, `bank`, `banknumber`, `firstname`, `lastname`, `sex`, `twitter`, `dob`, `rank`, `job`, `secondaryJob`, `gang`, `position`, `phone`, `wallpaper`, `metaData`, `bloodtype`, `jail`) VALUES (@identifier, @name, @cid, @citizenid, @cash, @bank, @banknumber, @firstname, @lastname, @sex, @twitter, @dob, @rank, @job, @secondaryJob, @gang, @position, @phone, @wallpaper, @metaData, @bloodtype, @jail)', {
        ['identifier'] = steam,
        ['name'] = GetPlayerName(src),
        ['cid'] = cData.cid,
        ['citizenid'] = string.sub(steam..cData.cid ,14),
        ['cash'] = RevivalFramework.DefaultSettings['startCash'],
        ['bank'] = RevivalFramework.DefaultSettings['startBank'],
        ['banknumber'] = math.random(10000000, 99999999),
        ['firstname'] = cData.firstname,
        ['lastname'] = cData.lastname,
        ['sex'] = cData.sex,
        ['twitter'] = string.upper(cData.firstname.."_"..cData.lastname),
        ['dob'] = cData.dob,
        ['rank'] = RevivalFramework.DefaultSettings['rank'],
        ['job'] = json.encode(RevivalFramework.DefaultSettings['job']),
        ['secondaryJob'] = RevivalFramework.DefaultSettings['secondaryJob'],
        ['gang'] = RevivalFramework.DefaultSettings['gang'],
        ['position'] = json.encode(RevivalFramework.DefaultSettings['spawnPosition']),
        ['phone'] = "05"..math.random(3,5)..math.random(10000,39999),
        ['wallpaper'] = "https://cdn.discordapp.com/attachments/685902475043012662/1067652125980631040/3933780E-84EC-474C-99D8-F0CFC3C57BDA.JPG",
        ["metaData"] = json.encode(meta),
        ['bloodtype'] = RevivalFramework.Bloodtypes[math.random(1, #RevivalFramework.Bloodtypes)],
        ['jail'] = 0,
    })
    if saveCharacter then
        print('^1[Revival-Framework] ^4- New Character Created')
        AddLog(src, 'base', "New Character Created("..GetPlayerName(src)..")\nfullname: "..cData.firstname..' '..cData.lastname..'('..cData.cid..')\nBitrhday: '..cData.dob)
    else
        print("Something Happend?")
    end
end)

RegisterCommand("logout", function(source, args)
    if not RevivalCore["Characters"][source] then
        TriggerClientEvent("revival-base:SessionStarted", source)
    end
end)

RegisterServerEvent("revival-multicharacters:visiable")
AddEventHandler("revival-multicharacters:visiable", function()
    local src = source;
    SetPlayerRoutingBucket(src, 0)
end)

RegisterServerEvent("revival-multicharacters:GetPlayers")
AddEventHandler("revival-multicharacters:GetPlayers", function()
	TriggerClientEvent('revival-multicharacters:GetPlayers', source, source, GetNumPlayerIndices(), GetConvarInt("sv_maxclients", 32)) -- todo chane slots here
end)

GetSteamID = function(source)
    local steam = "not found";
    for k,v in pairs(GetPlayerIdentifiers(source)) do
        if string.find(v,"license:") then
            steam = v;
        end
    end
    return steam;
end