# 🏦 rose-atmrobbery

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
Config.ReqItems = {
  phone = "phone",
  microsdcard = "microsdcard"
}

Config.Durations = {
  installMicroSDCard = 4000,
  pinCrackerDuration = 10000,
  waitSystemDown = 6000,
  grabMoney = 4000,
}

Config.Rewards = {
  min = 500,
  max = 1500,
}

Config.MinPoliceReq = 1
Config.Target = "ox" -- or "qb"
Config.Inventory = "ox" -- or "qb"
Config.Jobs = { "police" }
```

## 🚀 Installation

Install [ox_lib](https://github.com/overextended/ox_lib)
Install [bd-minigames](https://github.com/baggeddev/bd-minigames)

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
