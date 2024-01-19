# Assemble Electronics Area

![Assembled electronics area]()

---

![Add enclosure support brace]()

---

![Add cable comb]()

---

![Install mounting brackets on PSU 1]()


![Install mounting brackets on PSU 2]()

---

![Install PSU into electronics area]()

---

![Push-fit AC inlet]()

---
## E-Stop Disassembly

To install your E-stop you must first disassemble it. Most E-stops split in two by spinning the button side
whilst keeping the body in place. To reassemble it, perform the aforementioned steps backwards.

![Disassemble e-stop]()

---

![Install e-stop]()

---
## AC Wiring

If you plan to use a VFD to power your spindle you can split the AC input going to the PSU to power your VFD as seen in this diagram.

Make sure that you have a fused inlet and that the fuse is rated to handle the load of both the VFD and PSU.

Consult your VFD manual for its correct wiring.

![AC Wiring diagram]()

---

## Mainboard Mounting

![Mainboard Mount with self-tappers]()

![Mainboard Mounted to extrusions]()

---

## DC Wiring

Depending on how you want to control your spindle, you may need to add a few extra PCBs.

This example is for a VFD controlled spindle that accepts a 0-10V analog signal to control spindle speed.

You may also require a relay to send an enable signal to your VFD. If you wish to control your spindle manually then you can safely ignore these extra components.

!!! note
    There is no standard for motor wire colors - the motor wires shown in this example do no correlate with the rest of the legend.

!!! warning
    For safety reasons it is always a good idea to wire your endstops in a normally closed configuration. This allows your machine to detect breaks in any of your cabling rather than you manually detecting a failed endstop circuit when the table tries to move off the end of an axis!

---

## Final Installation

![Fan installation]()

![Electronics cover installation]()

---

[Next Chapter: Pre-Flight Checks](./pre_flight_checks.md)