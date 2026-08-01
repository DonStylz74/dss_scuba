
# DSS Scuba

Enhance your FiveM server with an immersive diving experience tailored for the ESX framework. This script provides a full diving outfit and the ability to interact with underwater items, enriching your role-playing capabilities. It's easy to integrate, customize, and supports multiple languages.

## Getting Started

**DSS Scuba** keeps the original ed_scuba diving functionality while adding a custom underwater HUD, oxygen & depth monitoring (audio and visual), configurable depth warnings, deep-dive pressure damage, and maximum-depth protection.

## Original Scuba Features
- Complete Diving Outfit: Includes a diving suit, mask, fins, and oxygen tank.
- Underwater Item Interaction: Discover and interact with various underwater items.
- Easy Integration: Seamless addition to your existing ESX setup.
- Customizable: Adjust settings in config.lua to suit your server.
- Localization: Supports multiple languages via locale files.

## New Features
- Custom dual-gauge underwater HUD.
- Configourable display type, UI or ox_lib Nofitications
- Coloured visual & Audiable Warnings for tank oxygen and depth

The HUD displays:
- Displays oxygen percentage 
- Displays current diving depth in meters

Oxygen coloured warning status
- Above 25% White
- Below 25% Yellow
- Below 10% Red

Depth coloured warning status 
- Above to -100m	Normal
- -100m to -174m	Yellow warning
- -175m to -184m	Red warning

## Oxygen Sound Warnings:
| Oxygen | Warning | Sound |
|--------|---------|-------|
|75 & 50%| Normal Oxygen | 1 warning beep |
|  15%  | Low Oxygen | 3 warning beeps |
|  10%  | Critical Oxygen | 4 warning beeps |
|  5%   | Extreme Oxygen | 5 rapid warning beeps |
|  0%   | Oxygen Depleted | Scuba breathing assistance stops |

## Maximum Depth & Damage System
- -185m to -189m	Pressure damage begins - 1 HP/sec
- -190m to -194m	Higher pressure damage - 3 HP/sec
- -195m to -198m	Max pressure damage - 5 HP/sec
- -198m  -- Maximum depth reached - Player is pushed upward


### Preview 
<a href="https://www.youtube.com/watch?v=B5HTFTvI4-s"> https://www.youtube.com/watch?v=B5HTFTvI4-s </a>

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.

- ESX
- ox_inventory
- ox_lib

### Installing

1. Download the Script
2. Place the Script in your ressources folder
4. Edit config and locales if you want
5. Enjoy
6. Add this item in items.lua for ox inventory

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
			description = 'Diving equipment, swimming assitance',
			stack = false,
			client = {
				export = 'dss_scuba.wear'
			}
		},

## Authors

See also the list of

- **Don Stylz** - _Provided README Template_ - [Donz Skriptz](https://github.com/DonStylz74)


## License

This project is licensed under the [CC0 1.0 Universal](LICENSE.md)
Creative Commons License - see the [LICENSE.md](LICENSE.md) file for
details

## Acknowledgments

[wobozkyng](https://github.com/wobozkyng/esx_scuba) - Original ed_scuba Source code

