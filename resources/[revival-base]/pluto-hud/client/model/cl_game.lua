-- PRE SPAWN
local charSpawned = false
local StunDuration = 8000

local pedId, plyId = PlayerPedId(), PlayerId()

function GetPed()
    return pedId
end
function GetPlayer()
    return plyId
end

Citizen.CreateThread(function()
    while not charSpawned do
        DisplayRadar(0)
        Citizen.Wait(0)
    end
end)


function loadTaxData()
    local _,taxLevels = RPC.execute("GetTaxLevels")
    local taxes = {}
    for _,tax in ipairs(taxLevels) do
        taxes[tax.id] = tax.level
    end
    sendAppEvent("game", {
        taxLevels = taxes
    })
end


AddEventHandler("np-spawn:characterSpawned", function()
    charSpawned = true
    Citizen.CreateThread(function()
        DisplayRadar(0)
        SetRadarBigmapEnabled(true, false)
        Citizen.Wait(0)
        SetRadarBigmapEnabled(false, false)
        DisplayRadar(0)
        Citizen.Wait(0)
        local initialHudSettings = exports["pluto-hud"]:GetPreferences()
        exports["pluto-hud"]:sendAppEvent("preferences", initialHudSettings)
        exports["pluto-hud"]:sendAppEvent("hud", {
            display = true,
        })
        startHealthArmorUpdates()
    end)
  end)

  RegisterNetEvent("timeheader")
AddEventHandler("timeheader", function(pHour, pMinutes)
    setGameValue("time", ("%s:%s"):format(pHour > 9 and pHour or "0" .. pHour, pMinutes > 9 and pMinutes or "0" .. pMinutes))
end)


CreateThread(function()
    SetPedMinGroundTimeForStungun(pedId, StunDuration)
    SetEntityProofs(pedId, false, false, false, false, false, true, false, false)
    SetPlayerHealthRechargeMultiplier(plyId, 0.0)
    SetPlayerHealthRechargeLimit(plyId, 0.0)
    SetPedConfigFlag(pedId, 184, true)
    while true do
        if GetPed() ~= PlayerPedId() then
            pedId = PlayerPedId()
            SetPedMinGroundTimeForStungun(pedId, StunDuration)
            SetEntityProofs(pedId, false, false, false, false, false, true, false, false)
            SetPedConfigFlag(pedId, 184, true)
            SetPlayerHealthRechargeMultiplier(plyId, 0.0)
            SetPlayerHealthRechargeLimit(plyId, 0.0)
        end
        if GetPlayer() ~= PlayerId() then
            plyId = PlayerId()
            SetPlayerHealthRechargeMultiplier(plyId, 0.0)
            SetPlayerHealthRechargeLimit(plyId, 0.0)
        end
        SetRadarBigmapEnabled(false, false)
        Wait(2000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if IsPedInCover(GetPed(), 0) and not IsPedAimingFromCover(GetPed()) then
            DisablePlayerFiring(GetPed(), true)
        end
        Citizen.Wait(0)
    end
end)