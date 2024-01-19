# Introduction

Take a deep breath for a second and realize something.

You... yes **YOU**, are about to commit to wiring and programming a robot that can cut through metal, let alone your squishy human parts.
A machine that can easily electrocute you, cut you or set fire to your whole neighborhood if it's not given the respect it deserves.

**Please** give this machine the respect it deserves !!!

!!! warning

    Please follow the manual to the letter and perform any additional research you deem necessary before attempting to use Milo for the first time.

    If there is anything, and we mean _anything_ that you are curious or unsure about, you are more than welcome to ask us on our discord server.

    After all, you are special to us and we don't want you to get hurt.

Most importantly from everyone at the Millennium Machines team, have fun wiring your very first Milo!

---

## What To Expect

This manual and associated firmware is for the Milo V1.5 with a Mellow Fly CDYv3 control board installed in the internal electronics enclosure found in the machine base.

This manual will not cover external enclosures or the electronics compartment found in the Millennium Machines Casa enclosure - but where possible, it can still be used as a guideline for those other setups.

The firmware used in this manual will only consist of the basic 3-axis functions of the machine.

Touch probes, additional relays, toolsetters and other related add ons will not be part of this base firmware and therefore will not be present in this manual.

---

## RepRapFirmware

RRF is typically considered a 3D printing firmware, but in the last few years has begun to see more and more CNC features implemented.

RRF boards tend to operate over WiFi or Ethernet and do not stream gcode over the air, but rather load it onto the board before starting a machining operation. Keep this in mind when finding a place to store Milo, as you will need some form of connection to the control board to allow working with the machine itself.

RRF is extremely control board agnostic, so for the most part firmwares can be shared between different control boards with only a few pin definitions needing to be changed.

Pins in RRF act a little differently from firmwares like Klipper and Marlin, as almost all pins are given a pin number (ex PC_7)
and a pin name (ex Xmin). It is generally the pin name that will be referenced in the firmware and not the pin number, meaning that Xmin on one control board will also be Xmin on others. Keep this in mind if you want to use a different control board from the one found in this manual.

It is still a good idea to cross reference these pins before changing any settings in firmware, and most control boards will come with a table similar to the one found [here](https://teamgloomy.github.io/fly_cdyv3_pins.html) - use this table in combination with a pinout diagram of your board to ensure everything will work as expected.

*[RRF]: RepRapFirmware

---

## Parts List and Printing Guidelines

The Millennium Machines team has provided a printing list with settings for you as a guideline for printing the parts necessary for the build. This list can be found [here](../../printing/print_guide.md#electronics-table).

Remember, these settings are only a guideline, and are open to your own interpretations - but we do highly recommend following them to achieve the best mechanical properties for each individual part.

### File Naming

With your STL files downloaded and your printer warmed up, you may be wondering which parts to print in your favorite colors? Have no fear, we've got your back - each file is labelled.

#### Primary Color

Example: `Handwheel Body x2.stl`
These files have no prefix in their filename so are safe to print in your primary color.

#### Accent Color

Example: `[a] Table Bolt Down Bracket A x2.stl`
These files are prefixed with `[a]` and are intended to be printed in your chosen accent color.

#### Quantity Required

Example: `Handwheel Body x2.stl`
If any file ends with `x#`, that is telling you the quantity of that part required to build the machine.

---

## Drilling Out Holes

To make some features printable without support, some features are printed with a sacrificial floor. These parts will need to be drilled and or cut out before use.

## T-Nuts Application

This machine requires an immense amount of T-nuts. In the interest of simplifying this manual, we have chosen to omit the installation of T-nuts. Wherever a part interfaces with an extrusion in a way that looks like it requires a T-nut, then it should be considered a part that requires a T-nut.

## CONTACT US

Building Milo can be confusing, but we're here to help.
Do you have a question?
Do you wanna show off your build?
Maybe you just want someone to chat with?
Well, why not join our community here on:

- :fontawesome-brands-discord: **Discord** [https://discord.gg/ya4UUj7ax2](https://discord.gg/ya4UUj7ax2)
- :fontawesome-brands-reddit: **Reddit** [/r/MilleniumMachines/](https://www.reddit.com/r/MilleniumMachines/)
- :fontawesome-brands-youtube: **YouTube** [Millennium Machine Works Official](https://www.youtube.com/channel/UCfdxXilZd76Dp8RfLxUJ_Gw)
- :fontawesome-brands-github: **GitHub** [https://github.com/MillenniumMachines](https://github.com/MillenniumMachines)

---

[Next Chapter: Installing RRF](./install_rrf.md)
