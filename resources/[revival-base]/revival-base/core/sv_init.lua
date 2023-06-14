RevivalCore 						= RevivalCore or {}
RevivalCore.Commands 			= {}
RevivalCore.CommandsSuggestions  = {}
RevivalCore.Characters			= {}
RevivalCore.offlineCharacter 	= {}
RevivalCore.lastPosition         = {}
RevivalCore.ServerCallbacks 		= {}
local serverStarted = false

RegisterServerEvent('RevivalCore:GetFunctions')
AddEventHandler('RevivalCore:GetFunctions', function(callback)
	callback(RevivalCore)
end)