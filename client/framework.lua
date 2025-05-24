Framework = {}

if Config.Framework == 'qbcore' then
    Framework.Core = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then
    Framework.Core = exports['es_extended']:getSharedObject()
else
    error('Invalid framework specified in Config.Framework: ' .. tostring(Config.Framework))
end

function Framework.GetPlayerData()
    if Config.Framework == 'qbcore' then
        return Framework.Core.Functions.GetPlayerData()
    elseif Config.Framework == 'esx' then
        return Framework.Core.GetPlayerData()
    end
    return {}
end

function Framework.IsPlayerDeadOrInLastStand(playerData)
    if Config.Framework == 'qbcore' then
        return playerData.metadata[Config.MetadataKeys.IsDead] or playerData.metadata[Config.MetadataKeys.InLastStand]
    elseif Config.Framework == 'esx' then
        return exports['esx_ambulancejob']:isDead() or exports['esx_ambulancejob']:isInLastStand()
    end
    return false
end

function Framework.Notify(message, notifyType)
    if Config.UseOxLib then
        lib.notify({
            title = 'Demise',
            description = message,
            type = Config.OxLibNotify[notifyType] or 'info',
            duration = 5000
        })
    else
        if Config.Framework == 'qbcore' then
            Framework.Core.Functions.Notify(message, Config.NotifyType[notifyType] or 'primary')
        elseif Config.Framework == 'esx' then
            Framework.Core.ShowNotification(message)
        end
    end
end

-- Check if player is busy
function Framework.IsPlayerBusy()
    if Config.UseOxLib then
        return lib.progressActive()
    else
        if Config.Framework == 'qbcore' then
            return exports['progressbar']:isDoingSomething()
        elseif Config.Framework == 'esx' then
            return false
        end
    end
    return false
end

function Framework.StartProgressBar(params, callback)
    if Config.UseOxLib then
        local success = lib.progressBar({
            duration = params.duration,
            label = params.label,
            useWhileDead = params.useWhileDead,
            canCancel = params.canCancel,
            disable = params.controlDisables
        })
        callback(not success)
    else
        if Config.Framework == 'qbcore' then
            exports['progressbar']:Progress(params, callback)
        elseif Config.Framework == 'esx' then

            CreateThread(function()
                local cancelled = false
                while exports['esx_progressbar']:IsProgressActive() do
                    Wait(0)
                    if IsControlJustPressed(0, 200) then -- Escape key
                        exports['esx_progressbar']:Cancel()
                        cancelled = true
                        break
                    end
                end
            end)
            
            exports['esx_progressbar']:Progressbar(params.label, params.duration, {
                FreezePlayer = true,
                animation = nil,
                onFinish = function()
                    callback(false)
                end,
                onCancel = function()
                    callback(true)
                end
            })
        end
    end
end