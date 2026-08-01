-- FULL UPDATED CLIENT FILE WITH NUI CIRCULAR GAUGE
-- Includes:
--   * NUI oxygen/depth gauge
--   * Maximum dive depth safety boundary at -195m
--   * Pressure damage:
--       -185m = 1 HP/sec
--       -190m = 3 HP/sec
--       -195m = 5 HP/sec
--
-- Existing scuba functionality otherwise unchanged.

local has_tank = false
local oxy_tank = false
local oxy_value = 0
local diving_swim = false
local current_scuba
lib.locale()

-- =========================================================
-- DEEP DIVE SAFETY SETTINGS
-- =========================================================

-- Maximum safe diving depth.
-- Kept above GTA V's approximate -200m boundary.
local MAX_DIVE_DEPTH = -195

-- Pressure damage per second.
local PRESSURE_DAMAGE_185 = 1
local PRESSURE_DAMAGE_190 = 3
local PRESSURE_DAMAGE_195 = 5

-- Prevents the maximum-depth notification from repeatedly
-- displaying every second while the player is at the boundary.
local depthBoundaryActive = false

exports("getoxy", function()
    return current_scuba and oxy_value / Config.fulltank * 100 or 0
end)

local lowOxy15Played = false
local lowOxy10Played = false
local lowOxy5Played = false

local function playBeeps(count)
    for i = 1, count do
        PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", true)
        Wait(600)
    end
end

local function oxyNotify(message, level)
    local notifyType = 'inform'
    local duration = 3000
    local title = 'Oxygen Status'
    if level >= 51 then
        notifyType = 'success'
        duration = 3500
        title = 'Tank Status: Good'
    elseif level >= 26 then
        notifyType = 'success'
        duration = 3500
        title = 'Tank Status: Moderate'
    elseif level >= 16 then
        notifyType = 'success'
        duration = 3500
        title = 'Tank Status: Low'
    elseif level >= 6 then
        notifyType = 'warning'
        duration = 4500
        title = 'Warning: Oxygen Getting Low'
    elseif level <= 5 then
        notifyType = 'error'
        duration = 5000
        title = 'Critical: Oxygen Danger Level'
    end

    lib.notify({
        title = title,
        description = message,
        type = notifyType,
        duration = duration
    })
end


---------------------------------------------------------
-- NUI Oxygen Gauge
---------------------------------------------------------
local function getDepth()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local waterHeight = GetWaterHeight(coords.x, coords.y, coords.z)
    if waterHeight then
        return math.floor((waterHeight - coords.z) * -1)
    end
    return 0
end

local function updateOxygenGauge(percent)
    if not Config.EnableOxygenUI then return end
    SendNUIMessage({
        action = "showOxygen",
        percent = percent,
        depth = getDepth()
    })
end

local function hideOxygenGauge()
    if not Config.EnableOxygenUI then return end
    SendNUIMessage({
        action = "hideOxygen"
    })
end


---------------------------------------------------------
-- Deep Dive Pressure Damage + Maximum Depth
---------------------------------------------------------
local function handleDeepDiveSafety(playerPed)
    local depth = getDepth()
    -- PRESSURE DAMAGE
    local pressureDamage = 0
    -- -185m to -189m
    if depth <= -185 and depth > -190 then
        pressureDamage = PRESSURE_DAMAGE_185
    -- -190m to -194m
    elseif depth <= -190 and depth > -195 then
        pressureDamage = PRESSURE_DAMAGE_190
    -- -195m and deeper
    elseif depth <= -195 then
        pressureDamage = PRESSURE_DAMAGE_195
    end

    if pressureDamage > 0 and not IsEntityDead(playerPed) then
        local health = GetEntityHealth(playerPed)
        -- Apply pressure damage but don't force health below 1.
        local newHealth = math.max(1, health - pressureDamage)
        SetEntityHealth(playerPed, newHealth)
    end


    ---------------------------------------------------------
    -- MAXIMUM DEPTH SAFETY BOUNDARY
    ---------------------------------------------------------
    if depth <= MAX_DIVE_DEPTH then
        local coords = GetEntityCoords(playerPed)
        -- Push the player upward 3 metres.
        -- This prevents the player from continuing toward
        -- GTA V's approximate -200m world boundary.
        SetEntityCoords(
            playerPed,
            coords.x,
            coords.y,
            coords.z + 3.0,
            false,
            false,
            false,
            false
        )
        -- Only show the notification once while the player
        -- remains at the maximum depth.
        if not depthBoundaryActive then
            depthBoundaryActive = true
            lib.notify({
                title = 'Maximum Dive Depth',
                description = 'Maximum safe diving depth reached. Ascending.',
                type = 'error',
                duration = 5000
            })
        end
    else
        depthBoundaryActive = false
    end
end


---------------------------------------------------------

RegisterNetEvent('ed_scuba:oxygenHandle', function(type, value)
    local playerPed = PlayerPedId()
    local pedModel = GetEntityModel(playerPed)
    if not isWearingScuba(playerPed, pedModel) then
        lib.showContext('seapanda_menu')
        return sendnotification(locale('not_equipped'))
    end

    local itemcount = getScubaItemCount(Config.scubaItemName)
    if itemcount < 1 then
        return sendnotification(locale('no_tank'))
    end
    if type == 'refill' then
        oxy_value = value and value / 100 * Config.fulltank or Config.fulltank
        sendnotification(
            locale(
                'tank_loaded',
                oxy_value / Config.fulltank * 100,
                '%'
            )
        )
        if Config.OxInventory then
            TriggerServerEvent("ed_scuba:updateMetadata", {
                slot = current_scuba,
                oxy = oxy_value / Config.fulltank * 100
            })
        end
    end
    if type == 'check' then
        local percent = math.floor(
            (oxy_value / Config.fulltank) * 100
        )
        oxyNotify(
            locale('tank_capacity', percent, '%'),
            percent
        )
    end
    if type == 'pay' then
        TriggerServerEvent('ed_scuba:oxygenRefillPay')
    end
end)


RegisterNetEvent('ed_scuba:wear', function(name)
    local playerPed = PlayerPedId()
    local pedModel = GetEntityModel(playerPed)
    local handle = applyScuba(
        name,
        playerPed,
        pedModel
    )
    if not handle.getScuba() then
        handle.setScuba()
    else
        if not Config.drop_to_reset then
            handle.resetScuba()
        end
    end
end)


ESX.RegisterInput(
    'scubalight',
    'Turn Scuba Light On/Off',
    'keyboard',
    Config.scubalightKeybind,
    function()
        local playerPed = PlayerPedId()
        local pedModel = GetEntityModel(playerPed)
        local LightEnabled =
            IsScubaGearLightEnabled(playerPed)
        if isWearingScuba(playerPed, pedModel) then
            SetEnableScubaGearLight(
                playerPed,
                not LightEnabled
            )
        end
    end
)


---------------------------------------------------------
-- ox_inventory integration (export wear)
---------------------------------------------------------

if Config.OxInventory then
    exports('wear', function(data, slot)
        TriggerEvent(
            'ed_scuba:wear',
            data.name
        )
        if data.name ~= "scuba_set" then
            return
        end
        current_scuba =
            current_scuba and nil or slot.slot
        oxy_value =
            slot.metadata?.oxy
            and slot.metadata.oxy / 100 * Config.fulltank
            or 0
        if current_scuba then
            TriggerServerEvent(
                "ed_scuba:equip",
                {
                    slot = slot.slot
                }
            )
            TriggerServerEvent(
                "ed_scuba:updateMetadata",
                {
                    slot = current_scuba,
                    oxy = oxy_value / Config.fulltank * 100
                }
            )
        end
    end)

    RegisterNetEvent(
        "ed_scuba:updateCurrent",
        function(data)
            current_scuba = data.slot
            if current_scuba == nil then
                TriggerEvent(
                    'ed_scuba:wear',
                    "scuba_set"
                )
            end
        end
    )

    AddEventHandler(
        'onResourceStop',
        function(resourceName)
            if resourceName ~= GetCurrentResourceName() then
                return
            end

            local playerPed = PlayerPedId()
            local pedModel = GetEntityModel(playerPed)
            if isWearingScuba(
                playerPed,
                pedModel
            )
            or isWearingScuba(
                playerPed,
                pedModel,
                true
            ) then
                local equipment = {
                    Config.scubaItemName,
                    Config.finsItemName
                }
                for i = 1, #equipment do
                    applyScuba(
                        equipment[i],
                        playerPed,
                        pedModel
                    ).resetScuba(true)
                end
            end
        end
    )

  else

    RegisterNetEvent(
        'ed_scuba:useItem',
        function(name)
            TriggerEvent(
                'ed_scuba:wear',
                name
            )
            if name ~= "scuba_set" then
                return
            end
            current_scuba =
                current_scuba and nil or 1
        end
    )


    RegisterNetEvent(
        'esx:removeInventoryItem'
    )


    AddEventHandler(
        'esx:removeInventoryItem',
        function(item, count)
            local playerPed = PlayerPedId()
            local pedModel = GetEntityModel(playerPed)
            if isWearingScuba(
                playerPed,
                pedModel
            )
            or isWearingScuba(
                playerPed,
                pedModel,
                true
            ) then
                local equipment = {
                    Config.scubaItemName,
                    Config.finsItemName
                }
                local items =
                    ESX.SearchInventory(
                        equipment,
                        true
                    )
                if items[item] and count < 1 then
                    applyScuba(
                        item,
                        playerPed,
                        pedModel
                    ).resetScuba()
                end
            end
        end
    )


    AddEventHandler(
        'onResourceStop',
        function(resourceName)
            if resourceName ~= GetCurrentResourceName() then
                return
            end

            local playerPed = PlayerPedId()
            local pedModel = GetEntityModel(playerPed)
            if isWearingScuba(
                playerPed,
                pedModel
            )
            or isWearingScuba(
                playerPed,
                pedModel,
                true
            ) then
                local equipment = {
                    Config.scubaItemName,
                    Config.finsItemName
                }
                for i = 1, #equipment do
                    applyScuba(
                        equipment[i],
                        playerPed,
                        pedModel
                    ).resetScuba(true)
                end
            end
        end
    )
end


---------------------------------------------------------
-- MAIN OXYGEN / DEPTH / PRESSURE LOOP
---------------------------------------------------------

CreateThread(function()
    if Config.EnableBlip then
        CreateBlips()
    end
    while true do
        local playerPed = PlayerPedId()
if IsPedSwimmingUnderWater(playerPed) then
    -------------------------------------------------
    -- DEPTH SAFETY + PRESSURE DAMAGE
    -------------------------------------------------
    handleDeepDiveSafety(playerPed)
    -------------------------------------------------
    -- SCUBA / OXYGEN
    -------------------------------------------------
    if oxy_tank then
        -------------------------------------------------
        -- OXYGEN AVAILABLE
        -------------------------------------------------
        if oxy_value > 0.0 then
            oxy_value -= 1
            -- Prevent going below zero
            if oxy_value < 0 then
                oxy_value = 0
            end
            local percent = math.floor(
                (oxy_value / Config.fulltank) * 100
            )
            -------------------------------------------------
            -- KEEP UI UPDATED
            -------------------------------------------------
            updateOxygenGauge(percent)
            -------------------------------------------------
            -- LOW OXYGEN WARNINGS
            -------------------------------------------------
            if percent <= 15
            and not lowOxy15Played then
                lowOxy15Played = true
                playBeeps(3)
                if not Config.EnableOxygenUI then
                    oxyNotify(
                        locale(
                            'tank_remaining',
                            percent,
                            '%'
                        ),
                        15
                    )
                end
            end
            if percent <= 10
            and not lowOxy10Played then
                lowOxy10Played = true
                playBeeps(4)
                if not Config.EnableOxygenUI then
                    oxyNotify(
                        locale(
                            'tank_remaining',
                            percent,
                            '%'
                        ),
                        10
                    )
                end
            end
            if percent <= 5
            and not lowOxy5Played then
                lowOxy5Played = true
                playBeeps(5)
                if not Config.EnableOxygenUI then
                    oxyNotify(
                        locale(
                            'tank_remaining',
                            percent,
                            '%'
                        ),
                        5
                    )
                end
            end
            if percent > 15 then
                lowOxy15Played = false
                lowOxy10Played = false
                lowOxy5Played = false
            end
            if tankAlert(oxy_value) then
                playBeeps(1)
                if not Config.EnableOxygenUI then
                    oxyNotify(
                        locale(
                            'tank_remaining',
                            percent,
                            '%'
                        ),
                        percent
                    )
                end
            end
        else
            -------------------------------------------------
            -- OXYGEN EMPTY
            -------------------------------------------------
            oxy_value = 0
            -- KEEP THE UI VISIBLE AT 0%
            updateOxygenGauge(0)
            -- IMPORTANT:
            -- Remove scuba breathing assistance.
            -- This allows the normal GTA underwater
            -- drowning/oxygen system to take over.
            SetPedConfigFlag(
                playerPed,
                3,
                true
            )
        end
    else
        -------------------------------------------------
        -- NO ACTIVE OXYGEN TANK
        -------------------------------------------------
        updateOxygenGauge(0)
        SetPedConfigFlag(
            playerPed,
            3,
            true
        )
    end
else
    -------------------------------------------------
    -- ABOVE WATER
    -------------------------------------------------
    hideOxygenGauge()
    depthBoundaryActive = false
end
        -------------------------------------------------
        -- ox_inventory metadata
        -------------------------------------------------
        if current_scuba
        and Config.OxInventory then
            TriggerServerEvent(
                "ed_scuba:updateMetadata",
                {
                    slot = current_scuba,
                    oxy = oxy_value / Config.fulltank * 100
                }
            )
        end
        Wait(1000)
    end
end)


---------------------------------------------------------
-- SCUBA / FINS HANDLING LOOP
---------------------------------------------------------

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local pedModel = GetEntityModel(playerPed)
        -----------------------------------------------------
        -- SCUBA TANK
        -----------------------------------------------------
        if isWearingScuba(
            playerPed,
            pedModel
        ) then
            has_tank = true
            if not oxy_tank
            and oxy_value > 1 then
                oxy_tank = true
                SetPedConfigFlag(
                    playerPed,
                    3,
                    false
                )
                sendnotification(
                    locale(
                        'tank_available',
                        oxy_value / Config.fulltank * 100,
                        '%'
                    )
                )
            end
        else
            has_tank = false
            hideOxygenGauge()
            if IsScubaGearLightEnabled(playerPed) then
                SetEnableScubaGearLight(
                    playerPed,
                    false
                )
            end
            if oxy_tank then
                oxy_tank = false
                SetPedConfigFlag(
                    playerPed,
                    3,
                    true
                )
                sendnotification(
                    locale(
                        'tank_not_available'
                    )
                )
            end
        end


        -----------------------------------------------------
        -- DIVING FINS
        -----------------------------------------------------
        if isWearingScuba(
            playerPed,
            pedModel,
            true
        ) then
            if not diving_swim then
                diving_swim = true
                SetEnableScuba(
                    playerPed,
                    true
                )
                sendnotification(
                    locale(
                        'diving_fins_equip'
                    )
                )
            end
        else
            if diving_swim then
                diving_swim = false
                SetEnableScuba(
                    playerPed,
                    false
                )
                sendnotification(
                    locale(
                        'diving_no_fins_equip'
                    )
                )
            end
        end
        Wait(500)
    end
end)