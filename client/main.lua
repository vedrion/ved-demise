-- GitHub: https://github.com/vedrion
-- Website: https://ved.tebex.io/

local lastdemiseTime = 0

function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

function CanUsedemiseCommand()
    local playerPed = PlayerPedId()
    local playerData = Framework.GetPlayerData()

    if Framework.IsPlayerDeadOrInLastStand(playerData) then
        Framework.Notify(Config.Messages.Dead, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsEntityDead(playerPed) or IsPedDeadOrDying(playerPed, true) then
        Framework.Notify(Config.Messages.Dying, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedRagdoll(playerPed) then
        Framework.Notify(Config.Messages.Ragdoll, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if GetEntityHealth(playerPed) <= Config.MinHealth then
        Framework.Notify(Config.Messages.LowHealth, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedCuffed(playerPed) then
        Framework.Notify(Config.Messages.Cuffed, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsEntityPlayingAnim(playerPed, Config.Anims.Handsup.Dict, Config.Anims.Handsup.Anim, 3) then
        Framework.Notify(Config.Messages.Handsup, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedInAnyVehicle(playerPed, true) then
        Framework.Notify(Config.Messages.InVeh, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedDoingDriveby(playerPed) then
        Framework.Notify(Config.Messages.Driveby, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedInParachuteFreeFall(playerPed) then
        Framework.Notify(Config.Messages.Para, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedFalling(playerPed) then
        Framework.Notify(Config.Messages.Falling, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedSwimming(playerPed) then
        Framework.Notify(Config.Messages.Water, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedUsingAnyScenario(playerPed) then
        Framework.Notify(Config.Messages.Scenario, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedInCover(playerPed, true) then
        Framework.Notify(Config.Messages.Cover, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedInMeleeCombat(playerPed) then
        Framework.Notify(Config.Messages.Melee, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedReloading(playerPed) then
        Framework.Notify(Config.Messages.Reloading, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedShooting(playerPed) then
        Framework.Notify(Config.Messages.Shooting, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedDiving(playerPed) then
        Framework.Notify(Config.Messages.Diving, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if Framework.IsPlayerBusy() then
        Framework.Notify(Config.Messages.Busy, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    return true
end

function DrawTimerText(timeLeft)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName("Time Left\n" .. timeLeft)
    SetTextFont(4)
    SetTextScale(0.7, 0.7)
    SetTextColour(255, 255, 255, 180)
    SetTextJustification(2)
    SetTextWrap(0.0, 0.95)
    SetTextOutline()
    EndTextCommandDisplayText(0.95, 0.45)
end

function KillYourself()
    local playerPed = PlayerPedId()
    local weapon = GetSelectedPedWeapon(playerPed)
    local hasGun = weapon and weapon ~= GetHashKey('WEAPON_UNARMED')
    local hasAmmo = hasGun and GetAmmoInPedWeapon(playerPed, weapon) > 0

    if hasGun and hasAmmo then
        local weaponGroup = GetWeapontypeGroup(weapon)
        if weaponGroup ~= GetHashKey('GROUP_PISTOL') then
            Framework.Notify(Config.Messages.NotPistol, 'Error')
            return
        end

        LoadAnimDict(Config.Anims.Thinking.Dict)
        SetCurrentPedWeapon(playerPed, weapon, true)
        ClearPedTasksImmediately(playerPed)
        TaskPlayAnim(playerPed, Config.Anims.Thinking.Dict, Config.Anims.Thinking.Anim, 8.0, 1.0, -1, 49, 0, false, false,
            false)

        Framework.Notify(Config.Messages.ThinkCancel, 'Warning', 6000)

        if Config.UseOxLib then
            CreateThread(function()
                while lib.progressActive() do
                    Wait(0)
                    if IsControlJustPressed(0, 200) then -- Escape key
                        lib.cancelProgress()
                        break
                    end
                end
            end)
        end

        Framework.StartProgressBar({
            name = "demise_countdown",
            duration = Config.ThinkDuration,
            label = Config.Messages.Thinking,
            useWhileDead = false,
            canCancel = true,
            controlDisables = Config.ControlDisables,
        }, function(cancelled)
            if cancelled then
                ClearPedTasksImmediately(playerPed)
            end

            if not cancelled then
                Framework.Notify(Config.Messages.Confirm, 'Warning', 10000)

                CreateThread(function()
                    local waiting = true
                    local timeExpire = Config.ExpireTime

                    CreateThread(function()
                        while waiting and timeExpire > 0 do
                            Wait(1000)
                            timeExpire = timeExpire - 1
                            if timeExpire <= 0 then
                                waiting = false
                                Framework.Notify(Config.Messages.Expired, 'Error')
                                ClearPedTasksImmediately(playerPed)
                                FreezeEntityPosition(playerPed, false)
                            end
                        end
                    end)

                    while waiting do
                        Wait(0)
                        DisableControlAction(0, 25, true)
                        DisablePlayerFiring(playerPed, true)

                        DrawTimerText(timeExpire)

                        if IsControlJustPressed(0, Config.Keys.Confirm) then
                            waiting = false
                            ClearPedTasksImmediately(playerPed)
                            LoadAnimDict(Config.Anims.demise.Dict)
                            TaskPlayAnim(playerPed, Config.Anims.demise.Dict, Config.Anims.demise.Anim, 8.0, 1.0, -1, 2,
                                0, false, false, false)
                            Wait(Config.demiseAnimWait)
           
                            local coords = GetEntityCoords(playerPed)
                            TriggerServerEvent('ved-demise:playGunshotSound', coords)
                            SetPedShootsAtCoord(playerPed, 0.0, 0.0, 0.0, 0)
                            SetEntityHealth(playerPed, 0)
                            Framework.Notify(Config.Messages.demiseSuccess, 'Primary')
                            ShakeGameplayCam(Config.CamShake.Type, Config.CamShake.Intensity)
                            FreezeEntityPosition(playerPed, false)
                        elseif IsControlJustPressed(0, Config.Keys.Cancel) then
                            waiting = false
                            Framework.Notify(Config.Messages.ChooseLife, 'Success')
                            ClearPedTasksImmediately(playerPed)
                            FreezeEntityPosition(playerPed, false)
                        end
                    end
                end)
            else
                Framework.Notify(Config.Messages.Cancelled, 'Success')
                SetPedCanRagdoll(playerPed, true)
                FreezeEntityPosition(playerPed, false)
            end
        end)
    else
        Framework.Notify(hasGun and Config.Messages.NoAmmo or Config.Messages.NoGun, 'Error')
    end
end

RegisterCommand(Config.CommandName, function()
    local currentTime = GetGameTimer() / 1000

    if not CanUsedemiseCommand() then return end

    if currentTime - lastdemiseTime < Config.Cooldown then
        local timeLeft = math.ceil(Config.Cooldown - (currentTime - lastdemiseTime))
        Framework.Notify(Config.Messages.Wait .. timeLeft .. Config.TimeSuffix, 'Error')
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return
    end

    lastdemiseTime = currentTime

    KillYourself()
end, false)

RegisterNetEvent('ved-demise:playGunshotSoundClient')
AddEventHandler('ved-demise:playGunshotSoundClient', function(coords)
    PlaySoundFromCoord(-1, "FIRING", coords.x, coords.y, coords.z, "DLC_HEIST_BIOLAB_WEAPONS", false, 50, false)
end)