RegisterServerEvent('revival_exports:money')
AddEventHandler('revival_exports:money', function(amount, action, account)
    local src = source
    local _char = exports['revival-base']:GetCharacter(src)
    if (account == 'cash') then
        if (action == 'remove') then
            _char.removeMoney(amount, 'cash')
        elseif (action == 'add') then
            local _char = exports['revival-base']:GetCharacter(src)
            _char.addMoney(amount, 'cash')
        end
    elseif (account == 'bank') then
        if (action == 'remove') then
            _char.removeMoney(amount, 'bank')
        elseif (action == 'add') then
            local _char = exports['revival-base']:GetCharacter(src)
            _char.addMoney(amount, 'bank')
        end
    end
end)

RegisterServerEvent('revival_exports:DoctorCount')
AddEventHandler('revival_exports:DoctorCount', function()
	local amount = 0
	for k, v in pairs(exports['revival-base']:GetCharacters()) do
        local _char = exports['revival-base']:GetCharacter(v)
        if _char ~= nil then 
            if (_char:job().name == 'ems') then
                amount = amount + 1
            end
        end
	end
    TriggerClientEvent("revival_exports:SetDoctorCount", -1, amount)
end)

RegisterServerEvent('revival_exports:OfficerCount')
AddEventHandler('revival_exports:OfficerCount', function()
	local amount = 0
	for k, v in pairs(exports['revival-base']:GetCharacters()) do
        local _char = exports['revival-base']:GetCharacter(v)
        if _char ~= nil then 
            if (_char:job().name == 'police') then
                amount = amount + 1
            
            end
        end
	end
    TriggerClientEvent("revival_exports:SetOfficerCount", -1, amount)
end)

RegisterCommand("money", function(source)
	local _char = exports['revival-base']:GetCharacter(source)
	TriggerClientEvent('notification', source, 'Cash: '.._char.cash..' | Bank: '.._char.bank)
end)