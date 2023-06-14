RevivalCore = RevivalCore or {}
RevivalCore.LocalPlayer = {}

RegisterNetEvent('RevivalCore:GetFunctions')
AddEventHandler('RevivalCore:GetFunctions', function(callback)
	callback(RevivalCore)
end)

RegisterNetEvent('revival-base:characterData')
AddEventHandler('revival-base:characterData', function(Data)
	RevivalCore.LocalPlayer = Data
end)

isOnline = false

RegisterNetEvent('revival-base:characterSpawned')
AddEventHandler('revival-base:characterSpawned', function()
    isOnline = true
	STARTGAMEPLAY()
	print("[revival-base] Player Init Loaded")
end)