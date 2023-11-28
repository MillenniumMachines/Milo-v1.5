# Frequently Asked Questions

## The Machine

### What is the work area of the Milo V1.5?

The standard (and recommended) work envelope is 340mm in X, 160mm in Y, and 60mm in Z.

The X and Z axis dimensions are customisable but we don't recommend anything more than 450-500mm in X and 80mm in Z with printed parts, and 120mm in Z with the Full Metal Jacket.

!!! warning
    If you want to extend your clearance in Z (the effective Z height), you will need to order longer C-Beam extrusions for the main column. This information is available in the [Sourcing Guide](./bom/sourcing_guide.md#frame).

!!! abstract
    Milo is a 'table slinger' - the spindle is stationary in X and Y, and the work table moves underneath it. The X and Y axes cannot move through the XY Gantry plate so the work area is limited by the dimensions of the gantry plate _as well as_ the length and thickness of the table.

    It is important to note that the Y axis cannot be made any longer than it already is, because the size limitation on the Y axis is dictated by how far the spindle sits out towards the operator from the main column.

    Extending the spindle outwards from the column any further than it already is would apply too much leverage against the column.

---

### What materials can the Milo V1.5 be used with?

This depends on the strength of your critical parts and the tooling you have, but the stock machine is capable of cutting wood and aluminium effectively. A machine with aluminium XY and Z gantry plates is even able to mill certain Steels (with caveats!).

---

### What is the Full Metal Jacket?

The FMJ is a modification for the Milo V1.5 that replaces the 3D printed Z-Axis joining plates with steel or aluminium jackets on either side. This improves the weight, rigidity and accuracy of the main column significantly, allowing it to be extended up to 120mm of clearance over the table.

The FMJ is not part of the standard design as it cannot itself be machined on Milo V1.5 due to its' size.

If you want to start your build with the FMJ, you will need to obtain 2 x 4080x320mm C-Beam extrusions instead of the standard 2 x 4080x260mm.

*[FMJ]: Full Metal Jacket

---

### Can I print the 3D printed parts out of Rainbow PLA / Orange PETG / Squeezy Cheese?
You can do anything you want, it is your machine after all, but your choice of filament has a direct impact on the quality and accuracy of parts you will be able to make on Milo.

The filament recommendations in the [BOM](./bom/sourcing_guide.md#printed-parts) are made for good reason - they have been tested by the design team over a long period of time and have been found to be stiff, strong and resilient where other filament choices were not.

!!! warning
    Using a different filament material will likely impact the strength and accuracy of your machine and this _could_ have safety implications.

---

### Where are the STL files for the XY Gantry Plate and the Z Gantry Plate?

There are none. This is a deliberate choice, as we strongly suggest new builds use machined plates - either from one of the [Kit suppliers](./bom/sourcing_guide.md#kits) or from another local source.

These plates can be printed but their strength and accuracy will have a direct impact on the quality of parts you can produce with Milo, and they are the first two parts that should be upgraded to metal once you have the ability to make them.

These parts can be extracted directly from the [CAD files](https://github.com/MilleniumMills/Millenium-Milo-v1.5/tree/main/CAD/) for local machining or printing.

---

### Why no Ball-screws?

Common ball-screw sizes just don't fit in the 4080 C-Beam that we use for the X,Y and Z axis mounts. We've looked high and low for a larger C-Beam that will fit them but can't find any. There are smaller 8 to 10mm ball-screws that do fit but they're expensive and will probably double the cost of the machine.

There are user mods to convert the machine to ball-screws but this is pretty involved and involves grinding the ball-screw nuts to fit into the extrusion channels. Needless to say this isn't appropriate for a first Milo build :sweat_smile:

---

### What Motors or Drivers should I use?

The parts outlined in the [Sourcing Guide](./bom/sourcing_guide.md#electronics) will get you a well rounded machine that is capable and relatively performant. The assembly manual and electronics manual were written with these parts in mind, so they are _by far_ the quickest route to getting a Milo V1.5 up and running.

If you want to size-up your motors then you will likely need to use bigger drivers, and you will be adding extra weight to each axis - every step up in size and power has a trade-off.

If in any doubt, just follow the recommendations in the sourcing guide - build a working machine and start milling things, which will give you a good idea of where your machine is capable or could be upgraded for your particular use-case.

---

### What Spindle / VFD should I use?

Most existing serialed builds are using round, 65 or 80mm, 1.5-2.2kW water-cooled spindles as outlined in the [BOM](./bom/sourcing_guide.md#electronics). These are the easiest spindles to source and fit.

You should buy a VFD that matches the power requirement of your spindle. If you would like to control your spindle automatically via gcode, then you will need to find a VFD that has at least one digital input (enable signal) and one 0-10v analogue input (spindle RPM control).

!!! note
    Again, bigger is not always better. It is quite unlikely that you will be able to use the full power of a 2.2kW spindle, let alone a larger one on a machine of this size.

---

### What End Mills should I buy?

There's a lot to learn about end mills, but if you're looking to work with aluminium then the Dreanique Millennium Mill Starter Set is a great choice - you can find links to buy it in the [BOM](./bom/sourcing_guide.md#kits).

If you're new to milling then you probably want to buy two sets :sweat_smile:

---

## Millennium Machines

### I've noticed an error in the documentation or want to suggest an improvement!

Great! Please submit it as an issue on our [GitHub](https://github.com/MilleniumMills) under the relevant repository - or if you have the technical knowledge, we happily accept pull requests provided that they improve the content, relevance and accuracy of our documentation.