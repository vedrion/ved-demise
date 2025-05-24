RegisterNetEvent('ved-demise:playGunshotSound')
AddEventHandler('ved-demise:playGunshotSound', function(coords)
    TriggerClientEvent('ved-demise:playGunshotSoundClient', -1, coords)
end)