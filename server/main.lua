local QBCore, qbx, ESX = nil, nil, nil

local Framework = Config.Framework

if Framework == "qb" then QBCore = exports["qb-core"]:GetCoreObject() end
if Framework == "qbx" then qbx = exports.qbx_core end
if Framework == "esx" then ESX = exports["es_extended"].getSharedObject() end

-- CHECK JOB: If player job is police or any government jobs, player can't rob atm.

local function CheckJob(playerSrc)
    local playerJob
    if Framework == "qb" then
        local Player = QBCore.Functions.GetPlayer(playerSrc)
        if not Player then return end
        playerJob = Player.PlayerData.job.name
    elseif Framework == "qbx" then
        local Player = qbx:GetPlayer(playerSrc)
        if not Player then return end
        playerJob = Player.PlayerData.job.name
    elseif Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(playerSrc)
        playerJob = xPlayer.getJob()
    end
    return playerJob
end

-- for client

lib.callback.register("server:checkJob", function (source)
    local job = CheckJob(source)
    return job
end)

-- POLICE COUNT: Here always check police e

local function GetPoliceCount()
    local count = 0
    local jobs = Config.Jobs
    for i = 1, #jobs do
        if Framework == "qb" then
            count = QBCore.Functions.GetDutyCount(jobs[i])
        elseif Framework == "qbx" then
            count = qbx:GetDutyCountJob(jobs[i])
        elseif Framework == "ESX" then
            count = 0
            local xPlayers = ESX.GetPlayers()
            for _, playerId in ipairs(xPlayers) do
                local xPlayer = ESX.GetPlayerFromId(playerId)
                if xPlayer then
                    local job = xPlayer.getJob()
                    if job.name == jobs[i] and job.onDuty then
                        count = count + 1
                    end
                end
            end
        end
    end
    return count
end

-- Looping, for client

CreateThread(function()
    while true do
        Wait(10000)
        lib.callback.register("server:getPoliceCount", function ()
            count = GetPoliceCount()
            debug("Current police count: " .. count)
            return count
        end)
    end
end)

-- Finishin Rob and Add Money -- Configurable via config.lua

lib.callback.register("server:finishRob", function (source)
    if Framework == "qb" then
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return end
        local amount = math.random(Config.Rewards.min, Config.Rewards.max)
        Player.Functions.AddMoney('cash', amount)
    elseif Framework == "qbx" then
        local amount = math.random(Config.Rewards.min, Config.Rewards.max)
        qbx:AddMoney(source, 'cash', amount)
    elseif Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end
        local amount = math.random(Config.Rewards.min, Config.Rewards.max)
        xPlayer.addMoney(amount)
    end
end)

lib.callback.register("server:removeMicroSDCard", function (source)
    if Config.Inventory == "ox" then
        exports.ox_inventory:RemoveItem(source, Config.ReqItems.microsdcard, 1)
    elseif Config.Inventory == "qb" then
        exports['qb-inventory']:RemoveItem(source, Config.ReqItems.microsdcard, 1)
    end
end)

AddEventHandler("onResourceStart", function (resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
end)

AddEventHandler("onResourceStop", function (resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
end)