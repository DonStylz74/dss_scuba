lib.locale()
local saved_components = {}
local pedHandles = {}
local yes = locale('yes')

--[[ function tankAlert(value)
    if value % 100 == 0 then --75%, 50%, 25%
        return true
    end
    if value == 40 then --10%
        return true
    end
    if value <= 20 and value % 4 == 0 then --5%
        return true
    end
    return false
end ]]--

local lastAlert = -1

function tankAlert(value)
    local percent = math.floor((value / Config.fulltank) * 100)

    -- Alerts at 75%, 50%, 25%, 10%, 5%
    local alertLevels = {
        75, 50, 25
    }

    for _, lvl in ipairs(alertLevels) do
        if percent == lvl and percent ~= lastAlert then
            lastAlert = percent
            return true
        end
    end

    return false
end

function isWearingScuba(playerPed, pedModel, fins)
    local isMale = Config.pedsMale[pedModel] or false
    local isFemale = Config.pedsFemale[pedModel] or false
    local WearingScuba = (isMale and GetPedDrawableVariation(playerPed, 8) == Config.maleScubaVariation) or (isFemale and GetPedDrawableVariation(playerPed, 8) == Config.femaleScubaVariation) or false
    local WearingSwimFins = (isMale and GetPedDrawableVariation(playerPed, 6) == Config.maleSwimFins) or (isFemale and GetPedDrawableVariation(playerPed, 6) == Config.femaleSwimFins) or false
    if fins then
        return WearingSwimFins
    end
    return WearingScuba
end

function applyScuba(name, playerPed, pedModel)
    local self = {}
    local isMale = Config.pedsMale[pedModel] or false
    local isFemale = Config.pedsFemale[pedModel] or false
    local anim = {
		[Config.scubaItemName] = {
			dict = 'clothingtie',
			clip = 'try_tie_negative_a',
			flags = 51,
		},
        [Config.finsItemName] = {
			dict = 'random@domestic',
			clip = 'pickup_low',
			flags = 51,
		}
    }
    if name == Config.scubaItemName then
        function self.playAnim()
            ESX.Streaming.RequestAnimDict(anim[name].dict)
            TaskPlayAnim(playerPed, anim[name].dict, anim[name].clip, 3.0, 3.0, 1200, anim[name].flags, 0.0, false, false, false)
            RemoveAnimDict(anim[name].dict)
            Wait(1200)
        end
        function self.getScuba()
            return isWearingScuba(playerPed, pedModel)
        end
        function self.setScuba()
            saved_components[name] = {
                GetPedDrawableVariation(playerPed, 8),
                GetPedTextureVariation(playerPed, 8),
                GetPedPropIndex(playerPed, 1),
                GetPedPropTextureIndex(playerPed, 1)
            }
            self.playAnim(playerPed)
            SetPedComponentVariation(playerPed, 8, isMale and Config.maleScubaVariation or isFemale and Config.femaleScubaVariation or 0, 0, 0)
            SetPedPropIndex(playerPed, 1, isMale and Config.maleScubaMaskVariation or isFemale and Config.femaleScubaMaskVariation or 0, 0, 0)
        end
        function self.resetScuba(hard)
            if saved_components[name] then
                if not hard then
                    self.playAnim(playerPed)
                end
                SetPedComponentVariation(playerPed, 8, saved_components[name][1], saved_components[name][2], 0)
                SetPedPropIndex(playerPed, 1, saved_components[name][3], saved_components[name][4], 0)
            end
        end
    end
    if name == Config.finsItemName then
        function self.playAnim()
            ESX.Streaming.RequestAnimDict(anim[name].dict)
            TaskPlayAnim(playerPed, anim[name].dict, anim[name].clip, 3.0, 3.0, 1200, anim[name].flags, 0.0, false, false, false)
            RemoveAnimDict(anim[name].dict)
            Wait(1200)
        end
        function self.getScuba()
            return isWearingScuba(playerPed, pedModel, true)
        end
        function self.setScuba()
            saved_components[name] = {
                GetPedDrawableVariation(playerPed, 6),
                GetPedTextureVariation(playerPed, 6)
            }
            self.playAnim(playerPed)
            SetPedComponentVariation(playerPed, 6, isMale and Config.maleSwimFins or isFemale and Config.femaleSwimFins or 0, 0, 0)
        end
        function self.resetScuba(hard)
            if saved_components[name] then
                if not hard then
                    self.playAnim(playerPed)
                end
                SetPedComponentVariation(playerPed, 6, saved_components[name][1], saved_components[name][2], 0)
            end
        end
    end
    return self
end

function getScubaItemCount(name)
    if Config.OxInventory then
        return exports.ox_inventory:Search('count', name)
    end
    return ESX.SearchInventory(name, true)
end

local function CreateLocationBlips(locations, settings)
    if not settings then
        return
    end

    for _, location in ipairs(locations or {}) do
        if location.enableBlip == true then
            local blip = AddBlipForCoord(location.pos.x, location.pos.y, location.pos.z)

            SetBlipSprite(blip, settings.sprite or 1)
            SetBlipScale(blip, settings.scale or 0.5)
            SetBlipColour(blip, settings.colour or 0)
            SetBlipAsShortRange(blip, settings.shortRange ~= false)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(settings.name or 'Scuba')
            EndTextCommandSetBlipName(blip)
        end
    end
end

function CreateBlips()
    CreateLocationBlips(Config.Location_Shops, Config.ShopBlips)
    CreateLocationBlips(Config.Location_Refills, Config.RefillBlips)
end



function CreatePedAtLocation(location)
    RequestModel(GetHashKey(location.model))
    while not HasModelLoaded(GetHashKey(location.model)) do
        Wait(1)
    end

    local pedHandle = CreatePed(4, GetHashKey(location.model), location.pos.x, location.pos.y, location.pos.z, location.heading, false, true)
    SetEntityAsMissionEntity(pedHandle, true, true)
    SetBlockingOfNonTemporaryEvents(pedHandle, true)
    SetEntityInvincible(pedHandle, true)
    FreezeEntityPosition(pedHandle, true)

    exports.ox_target:addLocalEntity(pedHandle, {
        {
            name = 'dss_scuba:openShop',
            label = locale('name_menu'),
            icon = 'fa-solid fa-store',
            onSelect = function()
                lib.showContext('seapanda_menu')
            end,
        },
    })

    SetModelAsNoLongerNeeded(GetHashKey(location.model))
    return pedHandle
end

function CreateRefillProp(location, index)
    if not location or not location.model or not location.pos then
        return nil
    end

    local model = GetHashKey(location.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end

    local propHandle = CreateObject(model, location.pos.x, location.pos.y, location.pos.z, false, false, false)
    SetEntityHeading(propHandle, location.heading or 0.0)
    FreezeEntityPosition(propHandle, true)
    SetEntityAsMissionEntity(propHandle, true, true)

    exports.ox_target:addLocalEntity(propHandle, {
        {
            name = ('dss_scuba:oxygenRefill:%s'):format(index),
            label = locale('oxygen_tank'),
            icon = 'fa-solid fa-gauge-high',
            distance = 2.0,
            onSelect = function()
                local result = lib.alertDialog({
                    header = locale('confirmation'),
                    content = (locale('oxygen_refill_confirm')):format(Config.Currency, Config.refillPrice),
                    centered = true,
                    cancel = true,
                    labels = {
                        confirm = locale('yes'),
                        cancel = locale('no')
                    }
                })

                if result == 'confirm' then
                    TriggerEvent('ed_scuba:oxygenHandle', 'pay')
                else
                    ESX.ShowNotification(locale('refill_cancel'))
                end
            end,
        },
    })

    SetModelAsNoLongerNeeded(model)
    return propHandle
end

local refillPropHandles = {}

for _, location in ipairs(Config.Location_Shops or {}) do
    local pedHandle = CreatePedAtLocation(location)
    if pedHandle then
        table.insert(pedHandles, pedHandle)
    end
end

for index, location in ipairs(Config.Location_Refills or {}) do
    local propHandle = CreateRefillProp(location, index)
    if propHandle then
        table.insert(refillPropHandles, propHandle)
    end
end

local function confirmPurchase(itemLabel, price, serverEvent)
    local result = lib.alertDialog({
        header = locale('confirmation'),
        content = (locale('purchase_confirm')):format(itemLabel, Config.Currency, price),
        centered = true,
        cancel = true,
        labels = {
            confirm = locale('yes'),
            cancel = locale('no')
        }
    })

    if result == 'confirm' then
        TriggerServerEvent(serverEvent)
    else
        ESX.ShowNotification(locale('purchase_cancel'))
    end
end

local sellOptions = {}
for _, sellItem in ipairs(Config.SellItems or {}) do
    sellOptions[#sellOptions + 1] = {
        title = sellItem.label,
        description = (locale('sell_item_desc')):format(Config.Currency, sellItem.price),
        icon = 'fa-solid fa-dollar-sign',
        onSelect = function()
            local result = lib.alertDialog({
                header = locale('sell_confirmation'),
                content = (locale('sell_confirm')):format(sellItem.label, Config.Currency, sellItem.price),
                centered = true,
                cancel = true,
                labels = {
                    confirm = locale('yes'),
                    cancel = locale('no')
                }
            })

            if result == 'confirm' then
                TriggerServerEvent('ed_scuba:sellItem', sellItem.item)
            else
                ESX.ShowNotification(locale('sale_cancel'))
            end
        end
    }
end

lib.registerContext({
    id = 'seapanda_sell_menu',
    title = locale('sell_menu'),
    menu = 'seapanda_menu',
    options = sellOptions
})

lib.registerContext({
    id = 'seapanda_menu',
    title = locale('name_menu'),
    options = {
        {
            title = locale('diving_gear'),
            description = locale('diving_gear_desc'),
            icon = 'fa-solid fa-mask-face',
            onSelect = function()
                confirmPurchase(locale('diving_gear'), Config.prixTenuedeplongee, 'ed_scuba:prixtenuesplongee')
            end
        },
        {
            title = locale('diving_fins'),
            description = locale('diving_fins_desc'),
            icon = 'fa-solid fa-person-swimming',
            onSelect = function()
                confirmPurchase(locale('diving_fins'), Config.prixpalmesplongee, 'ed_scuba:prixpalmesplongee')
            end
        },
        {
            title = locale('sell_menu'),
            description = locale('sell_menu_desc'),
            icon = 'fa-solid fa-hand-holding-dollar',
            menu = 'seapanda_sell_menu'
        }
    }
})

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for _, pedHandle in ipairs(pedHandles) do
        if DoesEntityExist(pedHandle) then
            DeleteEntity(pedHandle)
        end
    end

    for _, propHandle in ipairs(refillPropHandles) do
        if DoesEntityExist(propHandle) then
            DeleteEntity(propHandle)
        end
    end
end)
