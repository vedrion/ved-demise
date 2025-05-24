fx_version 'cerulean'
game 'gta5'

author 'Ved'
description 'Customizable End-of-Life Script for QBCore/ESX/QBox'
version '1.1.0'

-- Website: https://ved.tebex.io/
-- GitHub: https://github.com/vedrion
-- Discord: https://discord.gg/DscAtV7r6J

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/main.lua'
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua' -- Only required if Config.UseOxLib is set to true
}

lua54 'yes'
