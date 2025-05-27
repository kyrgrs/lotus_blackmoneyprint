local QBCore = exports['qb-core']:GetCoreObject()

-- Malzeme Ekleme
RegisterNetEvent('addMaterials')
AddEventHandler('addMaterials', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local paperAmount = math.random(Config.MaterialRange.paper.min, Config.MaterialRange.paper.max)
    local inkAmount = math.random(Config.MaterialRange.ink.min, Config.MaterialRange.ink.max)
    
    Player.Functions.AddItem(Config.Items.paper, paperAmount)
    Player.Functions.AddItem(Config.Items.ink, inkAmount)
end)

-- Malzeme Kontrol Callback
QBCore.Functions.CreateCallback('checkMaterials', function(source, cb, requiredPaper, requiredInk)
    local Player = QBCore.Functions.GetPlayer(source)
    local paper = Player.Functions.GetItemByName(Config.Items.paper)
    local ink = Player.Functions.GetItemByName(Config.Items.ink)
    cb((paper and paper.amount >= requiredPaper) and (ink and ink.amount >= requiredInk))
end)

-- Malzeme Silme
RegisterNetEvent('removeMaterials')
AddEventHandler('removeMaterials', function(paper, ink)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(Config.Items.paper, paper)
    Player.Functions.RemoveItem(Config.Items.ink, ink)
end)

-- Karapara Ekleme
RegisterNetEvent('addBlackMoney')
AddEventHandler('addBlackMoney', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(Config.Items.black_money, amount)
end)