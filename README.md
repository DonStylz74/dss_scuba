
![Awesome ReadME](https://imgur.com/ayFLJGW.png)

# DSS Scuba

An expanded and modernised scuba diving resource for FiveM ESX, based on the original ed_scuba resource by Edmondio.

DSS Scuba keeps the original scuba equipment and oxygen system while adding a redesigned underwater experience, improved dive safety, expanded scuba shop functionality, dedicated oxygen refill stations, configurable location blips, and a cleaner purchase/sell workflow.

<h1 align="center" style="font-weight: bold;">FEATURES</h1>


<p align="center"><table border="1" cellspacing="0" cellpadding="6">
    <thead>
        <tr>
            <th>Feature</th>
            <th>Original ed_scuba</th>
            <th>DSS Scuba</th>
        </tr>
    </thead>
    <tbody>
        <tr><td>Scuba suit / oxygen tank</td><td>✅</td><td>✅</td></tr>
        <tr><td>Diving fins</td><td>✅</td><td>✅</td></tr>
        <tr><td>Scuba mask</td><td>✅</td><td>✅</td></tr>
        <tr><td>Scuba flashlight</td><td>✅</td><td>✅</td></tr>
        <tr><td>ESX support</td><td>✅</td><td>✅</td></tr>
        <tr><td>ox_inventory support</td><td>✅</td><td>✅</td></tr>
        <tr><td>Oxygen item metadata</td><td>✅</td><td>✅</td></tr>
        <tr><td>Configurable equipment prices</td><td>✅</td><td>✅</td></tr>
        <tr><td>Shop NPCs</td><td>✅</td><td>✅</td></tr>
        <tr><td>Paid oxygen refills</td><td>✅</td><td>✅</td></tr>
        <tr><td>Localisation</td><td>✅</td><td>✅</td></tr>
        <tr><td>Custom oxygen HUD</td><td>❌</td><td>✅</td></tr>
        <tr><td>Live depth display</td><td>❌</td><td>✅</td></tr>
        <tr><td>Colour-coded oxygen warnings</td><td>❌</td><td>✅</td></tr>
        <tr><td>Audible low-oxygen warnings</td><td>Basic</td><td>Expanded</td></tr>
        <tr><td>Depth warning system</td><td>❌</td><td>✅</td></tr>
        <tr><td>Pressure damage</td><td>❌</td><td>✅</td></tr>
        <tr><td>Maximum depth protection</td><td>❌</td><td>✅</td></tr>
        <tr><td>Dedicated oxygen refill props</td><td>❌</td><td>✅</td></tr>
        <tr><td>Shops/refills at independent locations</td><td>❌</td><td>✅</td></tr>
        <tr><td>Separate shop/refill blip styling</td><td>❌</td><td>✅</td></tr>
        <tr><td>Per-location blip enable/disable</td><td>❌</td><td>✅</td></tr>
        <tr><td>Sell scuba equipment to shop</td><td>❌</td><td>✅</td></tr>
        <tr><td>Configurable sell items/prices</td><td>❌</td><td>✅</td></tr>
        <tr><td>Yes / No purchase buttons</td><td>❌</td><td>✅</td></tr>
        <tr><td>Yes / No refill confirmation</td><td>❌</td><td>✅</td></tr>
        <tr><td>Yes / No sell confirmation</td><td>❌</td><td>✅</td></tr>
    </tbody>
</table></p>


<p align="center">
<a href="https://github.com/ShaanCoding">📱 Visit this Project</a>
</p>

## Getting Started

DSS Scuba adds a custom underwater HUD that is displayed while the player is underwater and actively using scuba equipment.

The HUD displays:

- Current oxygen percentage
- Current diving depth in metres
- Colour-based oxygen warnings
- Colour-based depth warnings


Oxygen Warning System

- Above 25%	Normal
- 25% and below	Warning
- 10% and below	Critical

Audible Oxygen Warnings
- 75% / 50% / 25%	Single warning beep
- 15%	3 warning beeps
- 10%	4 warning beeps
- 5%	5 rapid warning beeps
- 0%	Scuba breathing assistance ends

Depth Monitoring & Dive Safety
Players who dive too deep begin taking pressure damage.

Diving Depth	Damage
- -185m to -189m	1 HP per second
- -190m to -194m	3 HP per second
- -195m and deeper	5 HP per second



<h2 id="layout">🎨 Layout</h2>

<p align="center">

<img src="https://imgur.com/CK9OmDO.png" alt="Gauge Warning Diagram" width="400px">
</p>

<h3>Prerequisites</h3>

DSS Scuba requires:

- ESX Legacy
- ox_lib
- ox_target
- ox_inventory
### Installation

1. Place dss_scuba inside your FiveM resources folder.
2. Ensure the required dependencies are installed and started.
3. Add the resource to your server configuration:
- ensure ox_lib
- ensure ox_target
- ensure ox_inventory
- ensure dss_scuba

4. Add the scuba items to your ox_inventory items configuration.

Example:
```yaml
['scuba_set'] = {
    label = 'Scuba Set',
    weight = 1000,
    description = 'Diving equipment, longer underwater',
    stack = false,
    client = {
        export = 'dss_scuba.wear'
    }
},

['scuba_fins'] = {
    label = 'Scuba Fins',
    weight = 250,
    description = 'Diving equipment, swimming assistance',
    stack = false,
    client = {
        export = 'dss_scuba.wear'
    }
},
```
5. Configure your shop locations:
```yaml
Config.Location_Shops = {
    -- Add scuba stores here
}
```
6. Configure your oxygen refill locations:
```yaml
Config.Location_Refills = {
    -- Add oxygen refill stations here
}
```
7. Configure shop prices, sell prices, refill price and blip settings.
8. Restart the resource or server.

## Authors

- **Don Stylz** - [Don_Stylz74](https://github.com/DonStylz74)


## License

Review the LICENSE file included with the resource for the licensing terms that apply to this version.

Because DSS Scuba is derived from an existing project, retain the appropriate original copyright, licence notices and attribution where required.
## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!


- [**wobozkyng** - Original Code](https://github.com/wobozkyng/esx_scuba)
- [**Edmondio** - Updated Code](https://github.com/Edmondio/ed_scuba)
