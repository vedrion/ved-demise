-- GitHub: https://github.com/vedrion
-- Website: https://ved.tebex.io/

local QBCore = exports['qb-core']:GetCoreObject()
local lastdemiseTime = 0

function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

function CanUsedemiseCommand()
    local playerPed = PlayerPedId()
    local PlayerData = QBCore.Functions.GetPlayerData()

    if PlayerData.metadata[Config.MetadataKeys.IsDead] then
        QBCore.Functions.Notify(Config.Messages.Dead, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if PlayerData.metadata[Config.MetadataKeys.InLastStand] then
        QBCore.Functions.Notify(Config.Messages.Unconscious, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsEntityDead(playerPed) or IsPedDeadOrDying(playerPed, true) then
        QBCore.Functions.Notify(Config.Messages.Dying, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedRagdoll(playerPed) then
        QBCore.Functions.Notify(Config.Messages.Ragdoll, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if GetEntityHealth(playerPed) <= Config.MinHealth then
        QBCore.Functions.Notify(Config.Messages.LowHealth, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedCuffed(playerPed) then
        QBCore.Functions.Notify(Config.Messages.Cuffed, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsEntityPlayingAnim(playerPed, Config.Anims.Handsup.Dict, Config.Anims.Handsup.Anim, 3) then
        QBCore.Functions.Notify(Config.Messages.Handsup, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedInAnyVehicle(playerPed, true) then
        QBCore.Functions.Notify(Config.Messages.InVeh, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedDoingDriveby(playerPed) then
        QBCore.Functions.Notify(Config.Messages.Driveby, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedInParachuteFreeFall(playerPed) then
        QBCore.Functions.Notify(Config.Messages.Para, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedFalling(playerPed) then
        QBCore.Functions.Notify(Config.Messages.Falling, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedSwimming(playerPed) then
        QBCore.Functions.Notify(Config.Messages.Water, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedUsingAnyScenario(playerPed) then
        QBCore.Functions.Notify(Config.Messages.Scenario, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedInCover(playerPed, true) then
        QBCore.Functions.Notify(Config.Messages.Cover, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedInMeleeCombat(playerPed) then
        QBCore.Functions.Notify(Config.Messages.Melee, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedReloading(playerPed) then
        QBCore.Functions.Notify(Config.Messages.Reloading, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedShooting(playerPed) then
        QBCore.Functions.Notify(Config.Messages.Shooting, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if IsPedDiving(playerPed) then
        QBCore.Functions.Notify(Config.Messages.Diving, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    if exports['progressbar']:isDoingSomething() then
        QBCore.Functions.Notify(Config.Messages.Busy, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return false
    end

    return true
end

function KillYourself()
    local playerPed = PlayerPedId()
    local weapon = GetSelectedPedWeapon(playerPed)
    local hasGun = weapon and weapon ~= GetHashKey('WEAPON_UNARMED')
    local hasAmmo = hasGun and GetAmmoInPedWeapon(playerPed, weapon) > 0

    if hasGun and hasAmmo then
        local weaponGroup = GetWeapontypeGroup(weapon)
        if weaponGroup ~= GetHashKey('GROUP_PISTOL') then
            QBCore.Functions.Notify(Config.Messages.NotPistol, Config.NotifyType.Error)
            return
        end

        LoadAnimDict(Config.Anims.Thinking.Dict)
        SetCurrentPedWeapon(playerPed, weapon, true)
        ClearPedTasksImmediately(playerPed)
        TaskPlayAnim(playerPed, Config.Anims.Thinking.Dict, Config.Anims.Thinking.Anim, 8.0, 1.0, -1, 49, 0, false, false,
            false)

        QBCore.Functions.Notify(Config.Messages.ThinkCancel, Config.NotifyType.Warning, 6000)
        exports['progressbar']:Progress({
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
                QBCore.Functions.Notify(Config.Messages.Confirm, Config.NotifyType.Warning, 10000)

                CreateThread(function()
                    local waiting = true
                    local timeExpire = Config.ExpireTime

                    CreateThread(function()
                        while waiting and timeExpire > 0 do
                            Wait(1000)
                            timeExpire = timeExpire - 1
                            if timeExpire <= 0 then
                                waiting = false
                                QBCore.Functions.Notify(Config.Messages.Expired, Config.NotifyType.Error)
                                ClearPedTasksImmediately(playerPed)
                                FreezeEntityPosition(playerPed, false)
                            end
                        end
                    end)

                    while waiting do
                        Wait(0)
                        DisableControlAction(0, 25, true)
                        DisablePlayerFiring(playerPed, true)

                        DrawRect(0.92, 0.5, 0.10, 0.07, 0, 0, 0, 150)

                        SetTextFont(0)
                        SetTextScale(0.30, 0.30)
                        SetTextColour(255, 100, 100, 255)
                        SetTextCentre(true)
                        SetTextEntry("STRING")
                        AddTextComponentString("Time left: ~w~" .. timeExpire .. "s")
                        DrawText(0.92, 0.475)

                        SetTextFont(0)
                        SetTextScale(0.25, 0.25)
                        SetTextColour(0, 255, 0, 255)
                        SetTextCentre(true)
                        SetTextEntry("STRING")
                        AddTextComponentString("~g~[E]~w~ Accept   ~y~[←--]~w~ Cancel")
                        DrawText(0.92, 0.503)

                        if IsControlJustPressed(0, Config.Keys.Confirm) then
                            waiting = false
                            ClearPedTasksImmediately(playerPed)
                            LoadAnimDict(Config.Anims.demise.Dict)
                            TaskPlayAnim(playerPed, Config.Anims.demise.Dict, Config.Anims.demise.Anim, 8.0, 1.0, -1, 2,
                                0, false, false, false)
                            Wait(Config.demiseAnimWait)
                            SetPedShootsAtCoord(playerPed, 0.0, 0.0, 0.0, 0)
                            SetEntityHealth(playerPed, 0)
                            QBCore.Functions.Notify(Config.Messages.demiseSuccess, Config.NotifyType.Primary)
                            ShakeGameplayCam(Config.CamShake.Type, Config.CamShake.Intensity)
                            FreezeEntityPosition(playerPed, false)
                        elseif IsControlJustPressed(0, Config.Keys.Cancel) then
                            waiting = false
                            QBCore.Functions.Notify(Config.Messages.ChooseLife, Config.NotifyType.Success)
                            ClearPedTasksImmediately(playerPed)
                            FreezeEntityPosition(playerPed, false)
                        end
                    end
                end)
            else
                QBCore.Functions.Notify(Config.Messages.Cancelled, Config.NotifyType.Success)
                SetPedCanRagdoll(playerPed, true)
                FreezeEntityPosition(playerPed, false)
            end
        end)
    else
        QBCore.Functions.Notify(hasGun and Config.Messages.NoAmmo or Config.Messages.NoGun, Config.NotifyType.Error)
    end
end

RegisterCommand(Config.CommandName, function()
    local currentTime = GetGameTimer() / 1000

    if not CanUsedemiseCommand() then return end

    if currentTime - lastdemiseTime < Config.Cooldown then
        local timeLeft = math.ceil(Config.Cooldown - (currentTime - lastdemiseTime))
        QBCore.Functions.Notify(Config.Messages.Wait .. timeLeft .. Config.TimeSuffix, Config.NotifyType.Error)
        PlaySoundFrontend(-1, Config.Sounds.Cooldown.Name, Config.Sounds.Cooldown.Sound, true)
        return
    end

    lastdemiseTime = currentTime

    KillYourself()
end, false)
