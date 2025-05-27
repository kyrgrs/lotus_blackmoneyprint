local QBCore = exports['qb-core']:GetCoreObject()
local missionActive = false
local stealZoneActive = false
local npc = nil
local currentStealZone = nil
local currentStealBlip = nil
local printerNpc = nil

-- Görev NPC'si Oluşturma ve Target Ekleme
Citizen.CreateThread(function()
    local npcModel = Config.NPC.model
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Wait(10)
    end
    npc = CreatePed(4, npcModel, Config.NPC.position.x, Config.NPC.position.y, Config.NPC.position.z, Config.NPC.position.w, false, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    TaskStartScenarioInPlace(npc, Config.NPC.scenario, 0, true)

    exports['qb-target']:AddTargetEntity(npc, {
        options = {{
            type = "client",
            event = "lotus_blackmoneyprint:startMission",
            icon = "fas fa-play",
            label = "Göreve Başla",
        }},
        distance = 2.5,
    })
end)

-- Printer NPC'si Oluşturma ve Target Ekleme
Citizen.CreateThread(function()
    local printerNpcModel = Config.PrinterNPC.model
    RequestModel(printerNpcModel)
    while not HasModelLoaded(printerNpcModel) do
        Wait(10)
    end
    printerNpc = CreatePed(4, printerNpcModel, Config.PrinterNPC.position.x, Config.PrinterNPC.position.y, Config.PrinterNPC.position.z, Config.PrinterNPC.position.w, false, true)
    SetEntityInvincible(printerNpc, true)
    FreezeEntityPosition(printerNpc, true)
    TaskStartScenarioInPlace(printerNpc, Config.PrinterNPC.scenario, 0, true)

    exports['qb-target']:AddTargetEntity(printerNpc, {
        options = {{
            type = "client",
            event = "openMoneyMenu",
            icon = "fas fa-print",
            label = "Para Bas",
        }},
        distance = 2.5,
    })
end)

-- Printer Zone ve Blip Ekleme
Citizen.CreateThread(function()
    local pos = Config.PrinterNPC.position
    local zoneVec3 = vector3(pos.x, pos.y, pos.z)
    exports['qb-target']:AddCircleZone("printerZone", zoneVec3, 1.5, {
        name = "printerZone",
        useZ = true,
        debugPoly = false
    }, {
        options = {{
            type = "client",
            event = "openMoneyMenu",
            icon = "fas fa-print",
            label = "Para Bas",
        }},
        distance = 2.5
    })
    -- Printer blip
    local printerBlip = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite(printerBlip, Config.BlipSettings.printerBlip.sprite)
    SetBlipColour(printerBlip, Config.BlipSettings.printerBlip.color)
    SetBlipScale(printerBlip, Config.BlipSettings.printerBlip.scale)
    SetBlipAsShortRange(printerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.BlipSettings.printerBlip.label)
    EndTextCommandSetBlipName(printerBlip)
end)

-- Görev Başlatma Eventi
RegisterNetEvent('lotus_blackmoneyprint:startMission')
AddEventHandler('lotus_blackmoneyprint:startMission', function()
    if not missionActive then
        missionActive = true
        QBCore.Functions.Notify("Görev başladı! Malzemeleri çalmaya git.", "success")
        ActivateRandomStealZone()
    else
        QBCore.Functions.Notify("Zaten bir görevdesin!", "error")
    end
end)

function ActivateRandomStealZone()
    if stealZoneActive or not Config.TargetVectors or #Config.TargetVectors == 0 then return end
    stealZoneActive = true
    local randomIndex = math.random(1, #Config.TargetVectors)
    local coord = Config.TargetVectors[randomIndex]
    local zoneName = "stealZone"

    -- Target zone ekle
    exports['qb-target']:AddCircleZone(zoneName, coord, 1.5, {
        name = zoneName,
        useZ = true,
        debugPoly = false
    }, {
        options = {{
            type = "client",
            event = "lotus_blackmoneyprint:stealMaterials",
            icon = "fas fa-box-open",
            label = "Malzemeleri Çal",
        }},
        distance = 2.5
    })
    currentStealZone = zoneName

    -- Blip ekle
    currentStealBlip = AddBlipForCoord(coord.x, coord.y, coord.z)
    SetBlipSprite(currentStealBlip, Config.BlipSettings.stealBlip.sprite or 1)
    SetBlipColour(currentStealBlip, Config.BlipSettings.stealBlip.color or 1)
    SetBlipScale(currentStealBlip, Config.BlipSettings.stealBlip.scale or 0.7)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.BlipSettings.stealBlip.label or "Malzeme Çalma Bölgesi")
    EndTextCommandSetBlipName(currentStealBlip)

    -- Redzone (radius blip) ekle
    currentStealRedzone = AddBlipForRadius(coord.x, coord.y, coord.z, 50.0)
    SetBlipColour(currentStealRedzone, 1) -- Kırmızı
    SetBlipAlpha(currentStealRedzone, 128)
end

RegisterNetEvent('lotus_blackmoneyprint:stealMaterials')
AddEventHandler('lotus_blackmoneyprint:stealMaterials', function()
    if missionActive then
        missionActive = false
        QBCore.Functions.Progressbar("steal_materials", "Malzemeler Çalınıyor...", Config.Timers.stealTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
        }, {
            animDict = 'anim@heists@box_carry@',
            anim = 'idle',
            flags = 49
        }, {}, {}, function()
            TriggerServerEvent('addMaterials')
            QBCore.Functions.Notify(Config.Notification.steal.success, 'success')
            RemoveStealZone()
        end, function()
            QBCore.Functions.Notify(Config.Notification.steal.cancel, 'error')
            missionActive = true
        end)
    else
        QBCore.Functions.Notify("Önce göreve başlamalısın!", "error")
    end
end)

function RemoveStealZone()
    if currentStealZone then
        exports['qb-target']:RemoveZone(currentStealZone)
        currentStealZone = nil
    end
    if currentStealBlip then
        RemoveBlip(currentStealBlip)
        currentStealBlip = nil
    end
    if currentStealRedzone then
        RemoveBlip(currentStealRedzone)
        currentStealRedzone = nil
    end
    stealZoneActive = false
end

-- Karapara Menüsü
RegisterNetEvent('openMoneyMenu')
AddEventHandler('openMoneyMenu', function()
    local menu = {{
        header = "Karapara Basma Menüsü",
        isMenuHeader = true
    }}
    for _, option in ipairs(Config.MoneyPrinterOptions) do
        menu[#menu+1] = {
            header = option.header,
            txt = "Gerekli: "..option.requiredPaper.." Kağıt, "..option.requiredInk.." Mürekkep",
            params = {
                event = "printMoney",
                args = option
            }
        }
    end
    menu[#menu+1] = {header = "Kapat", params = {event = "qb-menu:closeMenu"}}
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('printMoney')
AddEventHandler('printMoney', function(data)
    QBCore.Functions.TriggerCallback('checkMaterials', function(hasItems)
        if hasItems then
            QBCore.Functions.Progressbar("printing_money", "Para Basılıyor...", 10000, false, true, {
                disableMovement = true,
            }, {
                animDict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                anim = 'machinic_loop_mechandplayer',
            }, {}, {}, function()
                TriggerServerEvent('removeMaterials', data.requiredPaper, data.requiredInk)
                TriggerServerEvent('addBlackMoney', data.moneyAmount)
                QBCore.Functions.Notify(Config.Notification.printing.success, 'success')
            end, function()
                QBCore.Functions.Notify(Config.Notification.printing.cancel, 'error')
            end)
        else
            QBCore.Functions.Notify(Config.Notification.printing.noItems, 'error')
        end
    end, data.requiredPaper, data.requiredInk)
end)