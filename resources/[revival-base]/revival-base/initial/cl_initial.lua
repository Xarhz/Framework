RevivalCore = RevivalCore or {};
RevivalCore["init_loaded"] = false;

Citizen.CreateThread(function()
    while true do
        Wait(400)
        if NetworkIsSessionStarted() then
            TriggerEvent("revival-base:SessionStarted")
            return
        end
    end
end)

RevivalCore["Initialize"] = function()
    RevivalCore["SessionStarted"]()
end

RevivalCore["SessionStarted"] = function()
    local loaded = false;
    TriggerEvent("whenyouworkinghardfthenyourmoneystartexpandin", false)
    Citizen.CreateThread(function()
        TriggerEvent("inSpawn",true)
		SetEntityCoordsNoOffset(PlayerPedId(), vector3(-3972.28, 2017.22, 500.92), false, false, false, false)
		FreezeEntityPosition(PlayerPedId(), true)
        --while not HasCollisionForModelLoaded(GetHashKey("sp_01_station")) or not HasCollisionLoadedAroundEntity(PlayerPedId()) or not HasModelLoaded(GetHashKey("sp_01_station")) do
        --    RequestCollisionAtCoord(-3972.28, 2017.22, 500.92)
        --    print("Loading Collision")
            
           
        TriggerServerEvent('revival-multicharacters:GetCharacters');
        --print("map "..HasModelLoaded(GetHashKey("sp_01_station")) == 1 and "loaded" or "not loaded")
        --if HasModelLoaded(GetHashKey("sp_01_station")) then
            Init()
            Wait(250)
            DoScreenFadeIn(250)
        
        
    end)
end

function loading()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    TriggerEvent("loading:disableLoading")
    DoScreenFadeOut(250)
    Wait(400)
end

RegisterNetEvent("revival-base:SessionStarted")
AddEventHandler("revival-base:SessionStarted", function()
    RevivalCore["SessionStarted"]()
end)

RegisterNUICallback('play', function()
    DoScreenFadeOut(500)
    Wait(500)
    TriggerEvent("revival-base:spawnInitialized")
    Wait(3000)
    DoScreenFadeIn(1500)
    return
end)

RevivalCore["InitialSpawn"] = function() -- First spawn ever.
    CreateThread(function()
        DisableAllControlActions(0)
        local ped = PlayerPedId()
        FreezeEntityPosition(PlayerPedId(), false)
        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        EnableAllControlActions(0)
        TriggerEvent("revival-base:initial:finishedLoading")
    end)
end

RegisterNetEvent("revival-base:initial")
AddEventHandler("revival-base:initial", function()
    RevivalCore["InitialSpawn"]()
end)


RegisterNetEvent("revival-base:initial:finishedLoading")
AddEventHandler("revival-base:initial:finishedLoading", function()
    characterSpawned()
end)

function characterSpawned() -- First spawn events
    print("[revival-base] Character Successfully Spawned")
    TriggerServerEvent("revival-clothing:checkIt")
    TriggerServerEvent("revival-clothing:retrieve_tats")
    TriggerServerEvent("revival-base:licenses")
    TriggerEvent("player:receiveItem","idcard",1,true)
    TriggerEvent("player:receiveItem","mobilephone",1)
    Wait(550)
    TriggerEvent("revival-apartments:firstApartments")
end

function InitPlayer()
    CreateThread(function()
        DisableAllControlActions(0)
        DoScreenFadeOut(450) 
        local ped = PlayerPedId()
        -- SetEntityVisible(ped, true)
        FreezeEntityPosition(PlayerPedId(), false)
        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        EnableAllControlActions(0)
        TriggerEvent("revival-base:initial:player")
    end)
end

RegisterNetEvent("revival-base:initialPlayer")
AddEventHandler("revival-base:initialPlayer", function()
    InitPlayer()
end)


RegisterNetEvent("revival-base:initial:player")
AddEventHandler("revival-base:initial:player", function()
    characterLoaded()
end)

function characterLoaded()
    TriggerEvent("AttachWeapons")
    TriggerServerEvent("revival-clothing:retrieve_tats")
    TriggerServerEvent("revival-base:licenses")
    TriggerServerEvent("revival-weapons:getAmmo")
    TriggerServerEvent("revival-clothing:checkIt")
    TriggerServerEvent("apartments:load")
    Wait(450)
    DoScreenFadeIn(450)
	print("[revival-base] Character Successfully Loaded.")
end
