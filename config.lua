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

Config.EnableBlip = true -- enable blips for oxygen refill station

Config.BlipsName = 'Scuba Store' -- blips name if enabled

Config.EnableOxygenUI = true 

Config.Locations = {
    {pos = vector3(-1261.7573, -1434.0114, 4.347-1), heading = 126.742, model = "a_m_y_jetski_01"},  --Vespucci beach
    {pos = vector3(1308.9880, 4362.0610, 41.5455-1), heading =  254.4355, model = "a_m_y_jetski_01"},  --  Grapeseed
    {pos = vector3(-1601.5463, 5197.9375, 4.3632-1), heading =  298.2253, model = "a_m_y_jetski_01"},  --Paleto Cove
    {pos = vector3(3817.1997, 4483.0928, 6.3654-1), heading =  206.2764, model = "a_m_y_jetski_01"},  --San Chianski Mtn
    {pos = vector3(-3420.6746, 979.5411, 8.3467-1), heading =  1.4250, model = "a_m_y_jetski_01"},  --Chumush 
}

Config.Currency = '$'
Config.refillPrice = 300

Config.prixTenuedeplongee = 2500
Config.prixpalmesplongee = 350

-- ped component variations configuration
-- below is default ped assets, only added streamed scuba asset files
-- some may different if server have other replaced ped assets
Config.maleScubaVariation = 151 -- the scuba component number of the included stream file
Config.femaleScubaVariation = 153 -- the scuba component number of the included stream file
Config.maleScubaMaskVariation = 0
Config.femaleScubaMaskVariation = 28
Config.maleSwimFins = 67
Config.femaleSwimFins = 70

Config.fulltank = 900 -- full oxygen tank capacity, measure duration in seconds

Config.scubalightKeybind = 'H' -- default keybind to switch scuba flashlight on/off
Config.refillCommand = 'oxyrefill' -- command to manually refill oxygen tank capacity
Config.checkCommand = 'oxycheck' -- command to check oxygen tank capacity

Config.drop_to_reset = false -- need to drop scuba or fins to put off from ped

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
