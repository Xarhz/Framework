function SendUIMessage(data)
  SendReactMessage('uiMessage', data)
end

exports('SendUIMessage', SendUIMessage)

function sendAppEvent(app, data)
    local sentData = {
        app = app,
        data = data or {},
        source = "pluto-nui",
    }
    SendUIMessage(sentData)
end

exports("sendAppEvent", sendAppEvent)

function CloseReactAplication(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
    SetNuiFocus(false, false)
end

exports("CloseReactAplication", CloseReactAplication)

function OpenReactAplication(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
    SetNuiFocus(true, true)
end

exports("OpenReactAplication", OpenReactAplication)

RegisterNUICallback("pluto-hud:CloseAplication", function(data, cb) 
    SetNuiFocus(false, false)
end)

Citizen.CreateThread(function()
    TriggerEvent('_npx_uiReady')
end)


RegisterCommand("hud", function()
    SetNuiFocus(true, true)
    SendReactMessage('toggleSettings', {
        show = true
    })
end)

RegisterNUICallback('hideFrame', function()
    SetNuiFocus(false, false)
end)

function cashFlash(pCash)
    SendNUIMessage({
        action = "balance:showCash",
        data = pCash,
      })
end

exports("cashFlash", cashFlash)

function cashUpdate(pCurrentCash, pToUpdate)
    local cashState = {
        currentCash = pCurrentCash,
        toUpdate = pToUpdate,
      }
      SendNUIMessage({
        action = 'balance:updateCash',
        data = cashState,
      })
end

exports("cashUpdate", cashUpdate)
