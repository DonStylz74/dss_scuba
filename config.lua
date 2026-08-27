Config  = {}

Config.scubaItemName = 'scuba_set'
Config.finsItemName = 'scuba_fins'
Config.OxInventory = true -- enable ox_inventory support

Config.pedsMale = {
    [`mp_m_freemode_01`] = true, -- hash
    --
}

Config.pedsFemale = {
    [`mp_f_freemode_01`] = true, -- hash
    --
}

Config.EnableOxygenUI = true

Config.Currency = '$'
Config.refillPrice = 300

-- Shop purchase prices
Config.prixTenuedeplongee = 2500
Config.prixpalmesplongee = 350

-- Items the dive shop will buy back from players.
-- Add/remove entries here or change prices without editing client/server code.
Config.SellItems = {
    { item = Config.scubaItemName, label = 'Scuba Gear', price = 1250 },
    { item = Config.finsItemName, label = 'Diving Fins', price = 175 },
}

-- ped component variations configuration
-- below is default ped assets, only added streamed scuba asset files
-- some may different if server have other replaced ped assets
Config.maleScubaVariation = 151 -- the scuba component number of the included stream file
Config.femaleScubaVariation = 153 -- the scuba component number of the included stream file
Config.maleScubaMaskVariation = 0
Config.femaleScubaMaskVariation = 28
Config.maleSwimFins = 67
Config.femaleSwimFins = 70

Config.fulltank = 720 -- full oxygen tank capacity, measure duration in seconds

Config.scubalightKeybind = 'H' -- default keybind to switch scuba flashlight on/off
Config.refillCommand = 'oxyrefill' -- command to manually refill oxygen tank capacity
Config.checkCommand = 'oxycheck' -- command to check oxygen tank capacity

Config.drop_to_reset = false -- need to drop scuba or fins to put off from ped


-- ====================
-- SCUBA SHOP LOCATIONS
-- ====================
-- These locations only spawn the scuba shop NPC and shop target.
-- Set enableBlip = true/false for each individual shop.
Config.Location_Shops = {
    {
        pos = vector3(-1338.3289, -1261.0431, 3.8950),
        heading = 24.265,
        model = 'a_m_y_jetski_01',
        enableBlip = true,
    }, -- Vespucci Beach
    {
        pos = vector3(1561.7301, 3801.2632, 33.418),
        heading = 210.725,
        model = 'a_m_y_jetski_01',
        enableBlip = true,
    }, -- Sandyshores
    {
        pos = vector3(-1601.5463, 5197.9375, 4.3632-1),
        heading = 298.2253,
        model = 'a_m_y_jetski_01',
        enableBlip = true,
    }, -- Paleto Cove
    {
        pos = vector3(3817.1997, 4483.0928, 6.3654-1),
        heading = 206.2764,
        model = 'a_m_y_jetski_01',
        enableBlip = true,
    }, -- San Chianski Mtn
    {
        pos = vector3(-3420.6746, 979.5411, 8.3467-1),
        heading = 1.4250,
        model = 'a_m_y_jetski_01',
        enableBlip = true,
    }, -- Chumash
}

-- =======================
-- OXYGEN REFILL LOCATIONS
-- =======================
-- These locations only spawn the oxygen refill prop and refill target.
-- Set enableBlip = true/false for each individual refill point.
Config.Location_Refills = {
    {
        pos = vector3(-1335.45, -1260.52, 3.895),
        heading = 286.989,
        model = 'prop_compressor_03',
        enableBlip = false,
    }, -- Vespucci Beach
    {
        pos = vector3(1556.0540, 3800.2668, 33.435),
        heading = 21.879,
        model = 'prop_compressor_03',
        enableBlip = false,
    }, -- Grapeseed
    {
        pos = vector3(-1602.06, 5199.80, 3.363),
        heading = 324.166,
        model = 'prop_compressor_03',
        enableBlip = false,
    }, -- Paleto Cove
    {
        pos = vector3(3820.63, 4483.32, 4.992),
        heading = 24.153,
        model = 'prop_compressor_03',
        enableBlip = false,
    }, -- San Chianski Mtn
    {
        pos = vector3(-3424.61, 978.68, 7.346),
        heading = 355.178,
        model = 'prop_compressor_03',
        enableBlip = false,
    }, -- Chumash
}

-- ===========================
-- SHOP / REFILL BLIP SETTINGS
-- ===========================
-- Shared appearance settings for shop and oxygen refill blips.
-- Whether a blip is shown is controlled per location using enableBlip = true/false.
Config.ShopBlips = {
    name = 'Scuba Store',
    sprite = 729,
    colour = 0,
    scale = 0.5,
    shortRange = true,
}

Config.RefillBlips = {
    name = 'Oxygen Refill',
    sprite = 729,
    colour = 3,
    scale = 0.5,
    shortRange = true,
}


-- can be replaced with other notification function
if IsDuplicityVersion() then -- server notification
    sendnotification = function(xPlayer, text)
        if not xPlayer then
            return
        end
        xPlayer.showNotification(text)
    end
else -- client notification
    sendnotification = function(text)
        ESX.ShowNotification(text)
    end
end
