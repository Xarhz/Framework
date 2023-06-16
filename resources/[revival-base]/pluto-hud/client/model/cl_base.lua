local function restartUI(withMsg)
  SendReactMessage('restart', {show = true})
  if withMsg then
    TriggerEvent("DoLongHudText", "You can also use 'ui-r' as a shorter version to restart!")
  end
  Wait(1000)
  --local cj = exports["police"]:getCurrentJob()
end
RegisterCommand("pluto-hud:restart", function() restartUI(true) end, false)
RegisterCommand("ui-r", function() restartUI() end, false)
RegisterNetEvent("pluto-hud:server-restart")
AddEventHandler("pluto-hud:server-restart", restartUI)


function SetUIFocus(hasKeyboard, hasMouse)
  --  HasNuiFocus = hasKeyboard or hasMouse
    HasNuiFocus = hasKeyboard or hasMouse
    SetNuiFocus(hasKeyboard, hasMouse)
  
    -- TriggerEvent("np-voice:focus:set", HasNuiFocus, hasKeyboard, hasMouse)
    -- TriggerEvent("np-binds:should-execute", not HasNuiFocus)
end
exports('SetUIFocus', SetUIFocus)

RegisterCommand("np-ui:debug:show", function()
  SendUIMessage({ source = "np-nui", app = "debuglogs", data = { display = true } });
end, false)

RegisterCommand("np-ui:debug:hide", function()
  SendUIMessage({ source = "np-nui", app = "debuglogs", data = { display = false } });
end, false)

RegisterNUICallback("np-ui:resetApp", function(data, cb)
  SetUIFocus(false, false)
  cb({data = {}, meta = {ok = true, message = 'done'}})
  sendCharacterData()
end)

RegisterNetEvent("np-ui:server-relay")
AddEventHandler("np-ui:server-relay", function(data)
  SendUIMessage(data)
end)

