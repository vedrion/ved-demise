local cooldowns = {}

RegisterNetEvent("ved-demise:requestDemise")
AddEventHandler("ved-demise:requestDemise", function(coords)
    local src = source
    local now = os.time()

    if cooldowns[src] and now - cooldowns[src] < Config.Cooldown then
        print(("Player %d is trying to bypass demise cooldown."):format(src))
        return
    end

    if type(coords) ~= "table" or not coords.x or not coords.y or not coords.z then
        print(("Player %d sent invalid coords"):format(src))
        return
    end

    local ped = GetPlayerPed(src)
    local actualCoords = GetEntityCoords(ped)
    local dist = #(vector3(coords.x, coords.y, coords.z) - actualCoords)

    if dist > 10.0 then
        print(("Player %d sent spoofed coordinates too far from real position. Distance: %.2f"):format(src, dist))
        return
    end

    cooldowns[src] = now
    TriggerClientEvent("ved-demise:playGunshotSoundClient", -1, coords)
end)