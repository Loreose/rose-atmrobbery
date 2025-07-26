local attachedProp = nil
local hasSD = false

local function clearProp()
    if attachedProp and DoesEntityExist(attachedProp) then
        DeleteEntity(attachedProp)
        attachedProp = 0
    end
end

local function stopAnimation()
    ClearPedTasks(PlayerPedId())
    clearProp()
end

local function attachProp(prop, boneNo, xP, yP, zP, xRot, yRot, zRot)
    clearProp()
    local model = prop
    local boneNumber = boneNo
    SetCurrentPedWeapon(cache.ped, 0xA2719263, false)
    local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    attachedProp = CreateObject(model, 1.0, 1.0, 1.0, 1, 1, 0)
    local x, y, z = xP, yP, zP
    local xR, yR, zR = xRot, yRot, zRot
    AttachEntityToEntity(attachedProp, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 0, true, false, true, 2, true)
end

local function handleAnimation(dict, clip)
    local animDict = dict
    if not DoesAnimDictExist(animDict) then
        return false
    end
    RequestAnimDict(animDict)
    while (not HasAnimDictLoaded(animDict)) do Wait(10) end
    TaskPlayAnim(PlayerPedId(), animDict, clip, 5.0, 5.0, -1, 51, 0, false, false, false)
end

local function checkPhone()
    local hasDevice
        if Config.Inventory == "ox" then
            hasDevice = exports.ox_inventory:Search('count', Config.ReqItems.phone) > 0
        elseif Config.Inventory == "qb" then
            hasDevice = exports['qb-inventory']:HasItem(source, Config.ReqItems.phone) > 0
        end
    return hasDevice
end

local function UseMicroSDCard()
    debug("Used")
    lib.callback('server:checkJob', false, function(job)
        for i = 1, #Config.Jobs do
            if job == Config.Jobs[i] then
                lib.notify({type = "error", title = "Error", description = "You are a government man.", duration = 5000})
            else
                if checkPhone() then
                    if hasSD then
                        lib.notify({ type = "error", title = "Error", description =
                        "There is already an Micro SD card inside the phone", duration = 5000 })
                    else
                        if lib.progressBar({
                                duration = Config.Durations.installMicroSDCard,
                                label = "Installing Micro SD Card",
                                useWhileDead = false,
                                canCancel = true,
                                anim = {
                                    dict = "amb@code_human_wander_texting_fat@male@base",
                                    clip = "static",
                                },
                                prop = {
                                    model = "prop_phone_taymckenzienz",
                                    bone = 28422,
                                    pos = vec3(-0.01, -0.0150, 0.0),
                                    rot = vec3(0.0, 90.0, 0.0),
                                },
                                disable = {
                                    combat = true
                                }
                            }) then
                            lib.callback.await("server:removeMicroSDCard")
                            hasSD = true
                        end
                    end
                else
                    lib.notify({ type = "error", title = "Error", description = "You haven't the phone.", duration = 5000 })
                    debug("no")
                end
            end
        end
    end)
end

-- Use Micro SD Card item

if Config.Inventory == "ox" then
    AddEventHandler('ox_inventory:usedItem', function(name)
        if name == Config.ReqItems.microsdcard then
            UseMicroSDCard()
        end
    end)
elseif Config.Inventory == "qb" then
    AddEventHandler('QBCore:Client:UseItem', function (name)
        if name == Config.ReqItems.microsdcard then
            UseMicroSDCard()
        end
    end)
end

-- MAIN ROBBING FUNCTION

local function robATM(data)
    local ped = PlayerPedId()
    local model = nil
    if Config.Target == "qb" then
        model = data
    elseif Config.Target == "ox" then
        model = data.entity
    end
    local coords = GetEntityCoords(model)
    hasSD = false
    debug("robbing")
    TaskGoToEntity(ped, model, 1000, 0.5, 2.0, 1073741824, 0)
    while #(GetEntityCoords(ped) - coords) > 1.4 do
        Wait(100)
    end
    ClearPedTasks(ped)
    TaskTurnPedToFaceCoord(ped, coords.x, coords.y, coords.z, 1000)
    Wait(1000)
    handleAnimation("amb@code_human_wander_texting_fat@male@base", "static")
    attachProp("prop_phone_taymckenzienz", -0.01, -0.0150, 0.0, 0.0, 90.0, 0.0)
    local success = exports["bd-minigames"]:PinCracker(4, Config.Durations.pinCrackerDuration)
    if not success then
        lib.notify({
            title = "System Error",
            description = "You encountered an error.",
            type = "error",
            duration = 5000,
            icon = "fas fa-laptop-code"
        })
        stopAnimation()
    else
        debug(success)
        stopAnimation()
        if lib.callback.await("server:checkJob") == "police" then
            if Config.Dispatch == "qb" then
                TriggerEvent("police:client:policeAlert", coords, "ATM Robbery")
            elseif Config.Dispatch == "ps"  then
                exports["ps-dispatch"]:CustomAlert({
                    coords = coords.x,
                    coords.y,
                    coords.z,
                    message = "ATM Robbery",
                    alert = {
                        sprite = 272,
                        color = 2
                    },
                })
            end
        end
        lib.progressBar({
            duration = Config.Durations.waitSystemDown,
            label = "Waiting for the system to down.",
            useWhileDead = false,
            canCancel = false,
            disable = {
                combat = true,
                move = true,
                car = true,
            },
            anim = {
                dict = "random@shop_tattoo",
                clip = "_idle_a",
            }
        })
        if lib.progressBar({
                duration = Config.Durations.grabMoney,
                label = "Grabbing money",
                useWhileDead = false,
                canCancel = false,
                disable = {
                    combat = true,
                    move = true,
                    car = true,
                },
                anim = {
                    dict = "anim@scripted@heist@ig1_table_grab@cash@male@",
                    clip = "grab"
                }
            }) then
            stopAnimation()
            clearProp()
            lib.callback.await("server:finishRob")
        end
    end
end

-- TARGETS

local function addATMTarget()
    local models = Config.atms.models

    if Config.Target == "ox" then
        exports.ox_target:addModel(models, {
            label = "Run Pin Cracker",
            icon = "fas fa-keyboard",
            distance = 2,
            onSelect = function(data)
                local policeCount = lib.callback.await("server:getPoliceCount")
                if policeCount >= Config.MinPoliceReq then
                    robATM(data)
                else
                    lib.notify({type = "error", title = "Error", description = "Min police required: 1"})
                end
            end
        })
    elseif Config.Target == "qb" then
        exports['qb-target']:AddTargetModel(models, {
            options = {
                {
                    icon = "fas fa-keyboard",
                    label = "Run Pin Cracker",
                    action = function(entity)
                        local policeCount = lib.callback.await("server:getPoliceCount")
                        if policeCount >= Config.MinPoliceReq then
                            robATM(entity)
                        else
                            lib.notify({type = "error", title = "Error", description = "Min police required: 1"})
                        end
                    end,
                }
            },
            distance = 2
        })
    end
end

local function removeATMTarget()
    local models = Config.atms.models
    if Config.Target == "ox" then
        exports.ox_target:removeModel(models)
    elseif Config.Target == "qb" then
        exports['qb-target']:RemoveTargetModel(models)
    end
end

-- Checking player has phone with loop

local function playerHasPhone()
    local isTargetActive = false
    CreateThread(function()
        while true do
            Wait(1000)
            local hasDevice = checkPhone()
            if hasDevice and hasSD and not isTargetActive then
                addATMTarget()
                isTargetActive = true
            elseif (not hasDevice or not hasSD) and isTargetActive then
                removeATMTarget()
                isTargetActive = false
            end
        end
    end)
end

CreateThread(function ()
    playerHasPhone()
end)

RegisterCommand("checkpolice",function()
    local count = lib.callback.await("server:getPoliceCount")
    lib.notify({type = "inform", title = "Count", description = "Police Count: " .. count, duration = 5000})
end, false)

AddEventHandler("onResourceStart", function (resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
end)

AddEventHandler("onResourceStop", function (resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
end)