Config = {}

Config.Debug = false

Config.Framework = "qb"             -- qb, qbx, esx
Config.Inventory = "ox"             -- "qb", "ox"
Config.Target = "ox"                -- "qb", "ox"
Config.Dispatch = "qb"              -- "qb", "ps"

Config.MinPoliceReq = 1             -- Changeable

Config.Jobs = {                     -- If you have another government job, you add here
    "police",
}

Config.ReqItems = {                 -- The "itemname" field checks whether such an item exists in the selected inventory(Config.Inventory).
    phone = "phone",
    microsdcard = "microsdcard"
}

Config.Rewards = {
    min = 300,
    max = 1100
}

Config.Durations = {                -- Second * 1000
    pinCrackerDuration      = 30,   -- Minigame duration
    installMicroSDCard      = 5 * 1000,
    waitSystemDown          = 10 * 1000,
    grabMoney               = 5 * 1000,
}

Config.atms = {
    models = { "prop_atm_01", "prop_atm_02", "prop_atm_03", "prop_fleeca_atm" }
}

function debug(...)
    if Config.Debug then print("^3[DEBUG]^7", ...) end
end