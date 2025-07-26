# 🏦 ROSE ATM Robbery

A highly configurable and immersive ATM Robbery script for FiveM.  
This script supports QBCore, QBX, and ESX frameworks and includes advanced features like minigames, animation, item checks, and multi-framework inventory support.

---

## 🔧 Features

- 🎮 Minigame-based ATM robbery (`bd-minigames` required)
- 📱 Phone + Micro SD card check required before interaction
- 🧩 OX Inventory / QB Inventory support
- 🧠 Police job check and minimum police required logic
- 🎭 Animations and props (phone model shown while robbing)
- 🔁 Live target activation depending on player state (phone + SD)
- 🔧 Configurable dispatch integration (`qb-dispatch`, `ps-dispatch`)
- 💰 Reward system with min-max configurable range
- 🎯 Targeting system: both **OX Target** and **QB Target** supported

---

## 📂 Dependencies

- [`bd-minigames`](https://github.com/baggeddev/bd-minigames)
- [`ox_inventory`](https://github.com/overextended/ox_inventory) or [`qb-inventory`](https://github.com/qbcore-framework/qb-inventory)
- [`ox_target`](https://github.com/overextended/ox_target) or [`qb-target`](https://github.com/qbcore-framework/qb-target)
- Optional: [`ps-dispatch`](https://github.com/Project-Sloth/ps-dispatch)

---

## 🛠️ Configuration (`config.lua`)

Example:
```lua
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
```

## 🚀 Installation

- Install [ox_lib](https://github.com/overextended/ox_lib)
- Install [bd-minigames](https://github.com/kristiyanpts/bd-minigames))

1. Extract the `rose-atmrobbery` folder into your server's `resources` directory.
2. Extract the `ox_lib` folder into your server's `resources` directory.
3. Extract the `bd-minigames` folder into your server's `resources` directory.
4. Add the following line to your `server.cfg`:

```cfg
ensure ox_lib
ensure bd-minigames
ensure atmrobbery
```

## 🌐 Socials

[Discord](https://discord.gg/UY8Z3fRFZ5)
[Github](https://github.com/Loreose)
