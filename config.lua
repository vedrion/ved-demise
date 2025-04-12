Config = {}

-- The command to use to attempt demise.
Config.CommandName = "demise"

-- The cooldown in seconds between each demise attempt
Config.Cooldown = 30

-- The time in seconds before the player can cancel or proceed with the demise attempt
Config.ExpireTime = 120

-- The minimum health required to attempt demise
Config.MinHealth = 50

-- The time in milliseconds the player has to think before the demise attempt
Config.ThinkDuration = 7000

-- The time in milliseconds to wait for the headshot animation to finish
Config.demiseAnimWait = 800 -- WARNING: Tweak only if the animation timing needs adjustment

-- The suffix to use for the time in the messages
Config.TimeSuffix = " seconds"

-- The keys to use for confirming and cancelling the demise attempt
Config.Keys = {
    Confirm = 38, -- [E]
    Cancel = 202, -- [Backspace]
}

-- The metadata keys to check for the player's state
Config.MetadataKeys = {
    IsDead = "isdead",           -- WARNING: Changing may require code adjustments elsewhere
    InLastStand = "inlaststand", -- WARNING: Changing may require code adjustments elsewhere
}

-- The messages to display to the player
Config.Messages = {
    Dead = "You cannot perform this action while dead.",
    Unconscious = "You are unable to act while unconscious.",
    Dying = "You're too hurt to do this.",
    Ragdoll = "You can't do this while ragdolling.",
    LowHealth = "Your health is too low to do this.",
    Cuffed = "You can't do this while cuffed.",
    Handsup = "You can't do this with your hands up.",
    InVeh = "You can't do this while in a vehicle.",
    NoGun = "You need a gun to do this.",
    NoAmmo = "You have no ammo left.",
    Expired = "Your dark thought has expired.",
    NotPistol = "You can only use a pistol for this.",
    Thinking = "Thinking about life choices...",
    ThinkCancel = "Press [ESC] to cancel",
    Confirm = "Press [E] to confirm or [Backspace] to cancel.",
    Driveby = "You can't do this while in a drive-by.",
    Busy = "You are already doing something!",
    Para = "You can't do this while skydiving.",
    Falling = "You can't do this while falling.",
    Water = "You can't do this while in water.",
    Scenario = "You can't do this while in a scenario.",
    Cover = "You can't do this while in cover.",
    Melee = "You can't do this while in melee combat.",
    Reloading = "You can't do this while reloading.",
    Shooting = "You can't do this while shooting.",
    Diving = "You can't do this while diving.",
    demiseSuccess = "Please seek help from someone you trust.",
    ChooseLife = "You chose life. Good choice!",
    Cancelled = "The dark thought has passed.",
    Wait = "Take a deep breath, you can try again in ",
}

-- The types of notifications to display
Config.NotifyType = {
    Error = "error",
    Success = "success",
    Warning = "warning",
    Primary = "primary"
}

-- The animations to play for the demise attempt
Config.Anims = {
    Thinking = {
        Dict = "anim@mp_player_intupperface_palm",
        Anim = "idle_a"
    },
    demise = {
        Dict = "mp_suicide",
        Anim = "pistol"
    },

    Handsup = { -- Prevents using the command if the player has their hands up
        Dict = "missminuteman_1ig_2",
        Anim = "handsup_base"
    }
}

-- The controls to disable while the player is thinking
Config.ControlDisables = {
    disableMovement = true,
    disableCarMovement = true,
    disableMouse = false,
    disableCombat = true,
}
-- The sound to play when the player is unable to do something
Config.Sounds = {
    Cooldown = {
        Name = "ERROR",
        Sound = "HUD_AMMO_SHOP_SOUNDSET",
    },
}

-- The camera shake to apply when the player demises
Config.CamShake = {
    Type = "SMALL_EXPLOSION_SHAKE",
    Intensity = 0.5
}
