/**
  Copyright (C) 2012-2018 by Autodesk, Inc.
  All rights reserved.

  Mach3Mill post processor configuration.

  $Revision: 41981 b469d519b41034f7622245f52b01f620c0e5ec7e $
  $Date: 2020-07-31 19:59:58 $
  
  FORKID {A4D747BD-FEEF-4CE2-86CD-0D56966792FA}
*/

//Shem Johnson 2021 - Edited by AramcoPhil 2022

description = "Milo V1.5 Post by AramcoPhil";
vendor = "Millenium Machines";
vendorUrl = "https://www.millenniummachines.com/";
legal = "Copyright (C) 2012-2018 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 24000;

longDescription = "Milo V1.5 Post - No Toolsetter";

extension = "gcode";
setCodePage("ascii");

capabilities = CAPABILITY_MILLING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.1, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.1);
maximumCircularSweep = toRad(180);
allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow all circular planes Added by Shem to enable arcs

// user-defined properties
properties = {
  writeMachine: true, // write machine
  writeTools: true, // writes the tools
  writeVersion: true, // include version info
  useG28: true, // disable to avoid G28 output for safe machine retracts - when disabled you must manually ensure safe retracts
  useM6: false, // disable to avoid M6 output - preload is also disabled when M6 is disabled
  preloadTool: false, // preloads next tool on tool change if any
  showSequenceNumbers: false, // show sequence numbers
  sequenceNumberStart: 10, // first sequence number
  sequenceNumberIncrement: 5, // increment for sequence numbers
  separateWordsWithSpace: true, // specifies that the words should be separated with a white space
  useRadius: false, // specifies that arcs should be output using the radius (R word) instead of the I, J, and K words.
  dwellInSeconds: true, // specifies the unit for dwelling: true:seconds and false:milliseconds.
  useDustCollector: false, // specifies if M7 and M9 are output for dust collector
  useRigidTapping: "whitout", // output rigid tapping block
  homeOnToolChange: false,  //homes all axis after tool is changed and before it is potentailly probed
  probeToolOnChange: true, // probes a tool after changed in with by calling /macros/Tool Probe Auto
};

// user-defined property definitions
propertyDefinitions = {
  writeMachine: { title: "Write machine", description: "Output the machine settings in the header of the code.", group: 0, type: "boolean" },
  writeTools: { title: "Write tool list", description: "Output a tool list in the header of the code.", group: 0, type: "boolean" },
  writeVersion: { title: "Write version", description: "Write the version number in the header of the code.", group: 0, type: "boolean" },
  useG28: { title: "G28 Safe retracts", description: "Disable to avoid G28 output for safe machine retracts. When disabled, you must manually ensure safe retracts.", type: "boolean" },
  useM6: { title: "Use M6", description: "Disable to avoid outputting M6. If disabled Preload is also disabled", group: 1, type: "boolean" },
  preloadTool: { title: "Preload tool", description: "Preloads the next tool at a tool change (if any).", group: 1, type: "boolean" },
  showSequenceNumbers: { title: "Use sequence numbers", description: "Use sequence numbers for each block of outputted code.", group: 1, type: "boolean" },
  sequenceNumberStart: { title: "Start sequence number", description: "The number at which to start the sequence numbers.", group: 1, type: "integer" },
  sequenceNumberIncrement: { title: "Sequence number increment", description: "The amount by which the sequence number is incremented by in each block.", group: 1, type: "integer" },
  separateWordsWithSpace: { title: "Separate words with space", description: "Adds spaces between words if 'yes' is selected.", type: "boolean" },
  useRadius: { title: "Radius arcs", description: "If yes is selected, arcs are outputted using radius values rather than IJK.", type: "boolean" },
  dwellInSeconds: { title: "Dwell in seconds", description: "Specifies the unit for dwelling, set to 'Yes' for seconds and 'No' for milliseconds.", type: "boolean" },
  useDustCollector: { title: "Use dust collector", description: "Specifies if M7 and M9 are output for the dust collector.", type: "boolean" },
  useRigidTapping: {
    title: "Use rigid tapping",
    description: "Select 'Yes' to enable, 'No' to disable, or 'Without spindle direction' to enable rigid tapping without outputting the spindle direction block.",
    type: "enum",
    values: [
      { title: "Yes", id: "yes" },
      { title: "No", id: "no" },
      { title: "Without spindle direction", id: "without" }
    ]
  },
  homeOnToolChange: { title: "Home axis on tool change", description: "Homes all axis after tool is changed and before it is potentailly probed.", type: "boolean" },
  probeToolOnChange: { title: "Probe tool on tool change", description: "Probes a tool after changed in with by calling /macros/Tool Probe Auto.", type: "boolean" },
};

// samples:
// throughTool: {on: 88, off: 89}
// throughTool: {on: [8, 88], off: [9, 89]}
var coolants = {
  flood: { on: 8 },
  mist: { on: 7 },
  throughTool: { on: 8 },
  air: { on: 7 },
  airThroughTool: { on: 8 },
  suction: { on: 8 },
  floodMist: {},
  floodThroughTool: {},
  off: 9
};


var permittedCommentChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,=_-";

var nFormat = createFormat({ prefix: "N", decimals: 0 });
var gFormat = createFormat({ prefix: "G", decimals: 1 });
var mFormat = createFormat({ prefix: "M", decimals: 0 });
var hFormat = createFormat({ prefix: "H", decimals: 0 });
var pFormat = createFormat({ prefix: "P", decimals: (unit == MM ? 3 : 4), scale: 0.5 });
var xyzFormat = createFormat({ decimals: (unit == MM ? 3 : 4), forceDecimal: false });
var rFormat = xyzFormat; // radius
var abcFormat = createFormat({ decimals: 3, forceDecimal: false, scale: DEG });
var feedFormat = createFormat({ decimals: (unit == MM ? 0 : 1), forceDecimal: false });
var toolFormat = createFormat({ decimals: 0 });
var rpmFormat = createFormat({ decimals: 0 });
var secFormat = createFormat({ decimals: 3, forceDecimal: false }); // seconds - range 0.001-99999.999
var milliFormat = createFormat({ decimals: 0 }); // milliseconds // range 1-9999
var taperFormat = createFormat({ decimals: 1, scale: DEG });

var xOutput = createVariable({ prefix: "X" }, xyzFormat);
var yOutput = createVariable({ prefix: "Y" }, xyzFormat);
var zOutput = createVariable({ onchange: function () { retracted = false; }, prefix: "Z" }, xyzFormat);
var aOutput = createVariable({ prefix: "A" }, abcFormat);
var bOutput = createVariable({ prefix: "B" }, abcFormat);
var cOutput = createVariable({ prefix: "C" }, abcFormat);
var feedOutput = createVariable({ prefix: "F", force: false }, feedFormat);
var sOutput = createVariable({ prefix: "S", force: true }, rpmFormat);
var pOutput = createVariable({}, pFormat);

// circular output
var iOutput = createReferenceVariable({ prefix: "I", force: false }, xyzFormat);
var jOutput = createReferenceVariable({ prefix: "J", force: false }, xyzFormat);
var kOutput = createReferenceVariable({ prefix: "K", force: false }, xyzFormat);

var gMotionModal = createModal({ force: true }, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({ onchange: function () { gMotionModal.reset(); } }, gFormat); // modal group 2 // G17-19
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G93-94
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...
var gRetractModal = createModal({}, gFormat); // modal group 10 // G98-99

var WARNING_WORK_OFFSET = 0;

// collected state
var sequenceNumber;
var currentWorkOffset;
var retracted = false; // specifies that the tool has been retracted to the safe plane

/**
  Writes the specified block.
*/
function writeBlock() {
  var text = formatWords(arguments);
  if (!text) {
    return;
  }
  if (properties.showSequenceNumbers) {
    writeWords2(nFormat.format(sequenceNumber % 100000), arguments);
    sequenceNumber += properties.sequenceNumberIncrement;
  } else {
    writeWords(arguments);
  }
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(";" + filterText(String(text).toUpperCase(), permittedCommentChars));
}

function onOpen() {
  if (properties.useRadius) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
  }

  if (false) {
    var aAxis = createAxis({ coordinate: 0, table: true, axis: [-1, 0, 0], cyclic: true, preference: 1 });
    machineConfiguration = new MachineConfiguration(aAxis);

    setMachineConfiguration(machineConfiguration);
    optimizeMachineAngles2(1); // map tip mode
  }

  if (!machineConfiguration.isMachineCoordinate(0)) {
    aOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(1)) {
    bOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(2)) {
    cOutput.disable();
  }

  if (!properties.separateWordsWithSpace) {
    setWordSeparator("");
  }

  sequenceNumber = properties.sequenceNumberStart;

  if (programName) {
    writeComment(programName);
  }
  if (programComment) {
    writeComment(programComment);
  }

  //write program generation date and time
  let current_datetime = new Date();
  var date = current_datetime.getDate();
  var month = current_datetime.getMonth() + 1;
  var year = current_datetime.getFullYear();
  var hours = current_datetime.getHours();
  var minutes = current_datetime.getMinutes();
  var seconds = current_datetime.getSeconds();
  yearFormatted = year;
  monthFormatted = month < 10 ? "0" + month : month;
  dateFormatted = date < 10 ? "0" + date : date;
  hoursFormatted = hours < 10 ? "0" + hours : hours;
  minutesFormatted = minutes < 10 ? "0" + minutes : minutes;
  secondsFormatted = seconds < 10 ? "0" + seconds : seconds;
  writeln("");
  writeComment("Program created " + yearFormatted + "-" + monthFormatted + "-" + dateFormatted + "  " + hoursFormatted + "-" + minutesFormatted + "-" + secondsFormatted);
  writeln("");

  if (properties.writeVersion) {
    writeComment(localize("--- POST ---"));
    if ((typeof getHeaderVersion == "function") && getHeaderVersion()) {
      writeComment(localize("post version") + ": " + getHeaderVersion());
    }
    if ((typeof getHeaderDate == "function") && getHeaderDate()) {
      writeComment(localize("post modified") + ": " + getHeaderDate().replace(/:/g, "-"));
    }
    writeln("");
  }

  // dump machine configuration
  var vendor = machineConfiguration.getVendor();
  var model = machineConfiguration.getModel();
  var description = machineConfiguration.getDescription();

  if (properties.writeMachine && (vendor || model || description)) {
    writeComment(localize("Machine"));
    if (vendor) {
      writeComment("  " + localize("vendor") + ": " + vendor);
    }
    if (model) {
      writeComment("  " + localize("model") + ": " + model);
    }
    if (description) {
      writeComment("  " + localize("description") + ": " + description);
    }
  }

  // dump tool information
  if (properties.writeTools) {
    writeComment("--- Tools ---");
    var zRanges = {};
    if (is3D()) {
      var numberOfSections = getNumberOfSections();
      for (var i = 0; i < numberOfSections; ++i) {
        var section = getSection(i);
        var zRange = section.getGlobalZRange();
        var tool = section.getTool();
        if (zRanges[tool.number]) {
          zRanges[tool.number].expandToRange(zRange);
        } else {
          zRanges[tool.number] = zRange;
        }
      }
    }

    var tools = getToolTable();
    if (tools.getNumberOfTools() > 0) {
      for (var i = 0; i < tools.getNumberOfTools(); ++i) {
        var tool = tools.getTool(i);
        var comment = "T" + toolFormat.format(tool.number) + "  " +
          "D=" + xyzFormat.format(tool.diameter) + " " +
          localize("CR") + "=" + xyzFormat.format(tool.cornerRadius);
        if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
          comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
        }
        if (zRanges[tool.number]) {
          comment += " - " + localize("ZMIN") + "=" + xyzFormat.format(zRanges[tool.number].getMinimum());
        }
        comment += " - " + getToolTypeName(tool.type);
        writeComment(comment);
      }
    }
  }

  if (false) {
    // check for duplicate tool number
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var sectioni = getSection(i);
      var tooli = sectioni.getTool();
      for (var j = i + 1; j < getNumberOfSections(); ++j) {
        var sectionj = getSection(j);
        var toolj = sectionj.getTool();
        if (tooli.number == toolj.number) {
          if (xyzFormat.areDifferent(tooli.diameter, toolj.diameter) ||
            xyzFormat.areDifferent(tooli.cornerRadius, toolj.cornerRadius) ||
            abcFormat.areDifferent(tooli.taperAngle, toolj.taperAngle) ||
            (tooli.numberOfFlutes != toolj.numberOfFlutes)) {
            error(
              subst(
                localize("Using the same tool number for different cutter geometry for operation '%1' and '%2'."),
                sectioni.hasParameter("operation-comment") ? sectioni.getParameter("operation-comment") : ("#" + (i + 1)),
                sectionj.hasParameter("operation-comment") ? sectionj.getParameter("operation-comment") : ("#" + (j + 1))
              )
            );
            return;
          }
        }
      }
    }
  }

  if ((getNumberOfSections() > 0) && (getSection(0).workOffset == 0)) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      if (getSection(i).workOffset > 0) {
        error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
        return;
      }
    }
  }

  // print caution message
  bCautious();

  // absolute coordinates and feed per min
  writeBlock(gAbsIncModal.format(90));

  switch (unit) {
    case IN:
      writeBlock(gUnitModal.format(20));
      break;
    case MM:
      writeBlock(gUnitModal.format(21));
      break;
  }

  // if (properties.useDustCollector) {
  // writeBlock(mFormat.format(7)); // turns on dust collector
  // }
}

function onComment(message) {
  var comments = String(message).split(";");
  for (comment in comments) {
    writeComment(comments[comment]);
  }
}

/** Force output of X, Y, and Z. */
function forceXYZ() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
}

/** Force output of A, B, and C. */
function forceABC() {
  aOutput.reset();
  bOutput.reset();
  cOutput.reset();
}

/** Force output of X, Y, Z, A, B, C, and F on next output. */
function forceAny() {
  forceXYZ();
  forceABC();
  feedOutput.reset();
}

var currentWorkPlaneABC = undefined;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function setWorkPlane(abc) {
  if (!machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }

  if (!((currentWorkPlaneABC == undefined) ||
    abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
    abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
    abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z))) {
    return; // no change
  }

  onCommand(COMMAND_UNLOCK_MULTI_AXIS);

  if (!retracted) {
    writeRetract(Z);
  }

  writeBlock(
    gMotionModal.format(0),
    conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(abc.x)),
    conditional(machineConfiguration.isMachineCoordinate(1), "B" + abcFormat.format(abc.y)),
    conditional(machineConfiguration.isMachineCoordinate(2), "C" + abcFormat.format(abc.z))
  );

  onCommand(COMMAND_LOCK_MULTI_AXIS);

  currentWorkPlaneABC = abc;
}

var closestABC = false; // choose closest machine angles
var currentMachineABC;

function getWorkPlaneMachineABC(workPlane) {
  var W = workPlane; // map to global frame

  var abc = machineConfiguration.getABC(W);
  if (closestABC) {
    if (currentMachineABC) {
      abc = machineConfiguration.remapToABC(abc, currentMachineABC);
    } else {
      abc = machineConfiguration.getPreferredABC(abc);
    }
  } else {
    abc = machineConfiguration.getPreferredABC(abc);
  }

  try {
    abc = machineConfiguration.remapABC(abc);
    currentMachineABC = abc;
  } catch (e) {
    error(
      localize("Machine angles not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  var direction = machineConfiguration.getDirection(abc);
  if (!isSameDirection(direction, W.forward)) {
    error(localize("Orientation not supported."));
  }

  if (!machineConfiguration.isABCSupported(abc)) {
    error(
      localize("Work plane is not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  var tcp = true;
  if (tcp) {
    setRotation(W); // TCP mode
  } else {
    var O = machineConfiguration.getOrientation(abc);
    var R = machineConfiguration.getRemainingOrientation(abc, W);
    setRotation(R);
  }

  return abc;
}

function isProbeOperation() {
  return hasParameter("operation-strategy") && (getParameter("operation-strategy") == "probe");
}

function onSection() {
  var insertToolCall = isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number);

  retracted = false;
  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis()) ||
    (currentSection.isOptimizedForMachine() && getPreviousSection().isOptimizedForMachine() &&
      Vector.diff(getPreviousSection().getFinalToolAxisABC(), currentSection.getInitialToolAxisABC()).length > 1e-4) ||
    (!machineConfiguration.isMultiAxisConfiguration() && currentSection.isMultiAxis()) ||
    (!getPreviousSection().isMultiAxis() && currentSection.isMultiAxis() ||
      getPreviousSection().isMultiAxis() && !currentSection.isMultiAxis()); // force newWorkPlane between indexing and simultaneous operations
  if (insertToolCall || newWorkOffset || newWorkPlane) {

    if (properties.useG28) {
      // retract to safe plane
      writeBlock(gFormat.format(28), gAbsIncModal.format(91), "Z" + xyzFormat.format(125)); // retract
      writeBlock(gAbsIncModal.format(90));
      zOutput.reset();
    }
  }

  writeln("");

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeComment(comment);
    }
  }

  if (insertToolCall) {
    forceWorkPlane();

    onCommand(COMMAND_STOP_SPINDLE);
    if (!properties.useDustCollector) {
      setCoolant(COOLANT_OFF);
    }
    if (tool.number > 256) {
      warning(localize("Tool number exceeds maximum value."));
    }

    if (properties.useM6) {
      writeBlock("T" + toolFormat.format(tool.number), mFormat.format(6));
    } else {
      writeBlock("T" + toolFormat.format(tool.number));
    }
    if (properties.homeOnToolChange) {
      writeBlock(gFormat.format(28));
    }
    var showToolZMin = false;
    if (showToolZMin) {
      if (is3D()) {
        var numberOfSections = getNumberOfSections();
        var zRange = currentSection.getGlobalZRange();
        var number = tool.number;
        for (var i = currentSection.getId() + 1; i < numberOfSections; ++i) {
          var section = getSection(i);
          if (section.getTool().number != number) {
            break;
          }
          zRange.expandToRange(section.getGlobalZRange());
        }
        writeComment(localize("ZMIN") + "=" + zRange.getMinimum());
      }
    }

    if (properties.preloadTool && properties.useM6) {
      var nextTool = getNextTool(tool.number);
      if (nextTool) {
        writeBlock("T" + toolFormat.format(nextTool.number));
      } else {
        // preload first tool
        var section = getSection(0);
        var firstToolNumber = section.getTool().number;
        if (tool.number != firstToolNumber) {
          writeBlock("T" + toolFormat.format(firstToolNumber));
        }
      }
    }
    
  }
  if (insertToolCall ||
    isFirstSection() ||
    (tool.clockwise != getPreviousSection().getTool().clockwise)) {
    if (tool.spindleRPM < 1) {
      error(localize("Spindle speed out of range."));
      return;
    }
    if (tool.spindleRPM > 99999) {
      warning(localize("Spindle speed exceeds maximum value."));
    }
    var tapping = hasParameter("operation:cycleType") &&
      ((getParameter("operation:cycleType") == "tapping") ||
        (getParameter("operation:cycleType") == "right-tapping") ||
        (getParameter("operation:cycleType") == "left-tapping") ||
        (getParameter("operation:cycleType") == "tapping-with-chip-breaking"));
    if (!tapping || (tapping && !(properties.useRigidTapping == "without"))) {
      

    }
    //writeBlock(mFormat.format(98) + " P\"/macros/move-to-probe-location-in-g55.g\"");
    //writeBlock(mFormat.format(98) + " P\"/macros/set-tool-height-in-g55.g\"");
  }
  writeBlock(mFormat.format(tool.clockwise ? 3 : 4), pFormat.format(0), sOutput.format(tool.spindleRPM));
  writeBlock(gFormat.format(4) + " P15000");

  writeBlock(gFormat.format(56));

  forceXYZ();

  if (machineConfiguration.isMultiAxisConfiguration()) { // use 5-axis indexing for multi-axis mode
    // set working plane after datum shift

    var abc = new Vector(0, 0, 0);
    if (currentSection.isMultiAxis()) {
      forceWorkPlane();
      cancelTransformation();
    } else {
      abc = getWorkPlaneMachineABC(currentSection.workPlane);
    }
    setWorkPlane(abc);
  } else { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported."));
      return;
    }
    setRotation(remaining);
  }

  // set coolant after we have positioned at Z
  if (!properties.useDustCollector) {
    setCoolant(tool.coolant);
  }

  forceAny();
  gMotionModal.reset();

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  if (!retracted && !insertToolCall) {
    if (getCurrentPosition().z < initialPosition.z) {
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
    }
  }

  if (insertToolCall || retracted) {
    var lengthOffset = tool.lengthOffset;
    if (lengthOffset > 256) {
      error(localize("Length offset out of range."));
      return;
    }

    gMotionModal.reset();
    //writeBlock(gPlaneModal.format(17));

    if (!machineConfiguration.isHeadConfiguration()) {
      writeBlock(
        gAbsIncModal.format(90),
        gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y)
      );
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
    } else {
      writeBlock(
        gAbsIncModal.format(90),
        gMotionModal.format(0),
        gFormat.format(43), xOutput.format(initialPosition.x),
        yOutput.format(initialPosition.y),
        zOutput.format(initialPosition.z), hFormat.format(lengthOffset)
      );
    }
  } else {
    writeBlock(
      gAbsIncModal.format(90),
      gMotionModal.format(0),
      xOutput.format(initialPosition.x),
      yOutput.format(initialPosition.y)
    );
  }
}

function onDwell(seconds) {
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }
  if (properties.dwellInSeconds) {
    writeBlock(gFormat.format(4), "P" + secFormat.format(seconds));
  } else {
    milliseconds = clamp(1, seconds * 1000, 99999999);
    writeBlock(gFormat.format(4), "P" + milliFormat.format(milliseconds));
  }
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock(sOutput.format(spindleSpeed));
}


var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

function onRapid(_x, _y, _z) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      error(localize("Radius compensation mode cannot be changed at rapid traversal."));
      return;
    }
    writeBlock(gMotionModal.format(0), x, y, z);
    feedOutput.reset();
  }
}

function onLinear(_x, _y, _z, feed) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = feedOutput.format(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      //writeBlock(gPlaneModal.format(17));
      switch (radiusCompensation) {
        case RADIUS_COMPENSATION_LEFT:
          pOutput.reset();
          writeBlock(gMotionModal.format(1), pOutput.format(tool.diameter), gFormat.format(41), x, y, z, f);
          break;
        case RADIUS_COMPENSATION_RIGHT:
          pOutput.reset();
          writeBlock(gMotionModal.format(1), pOutput.format(tool.diameter), gFormat.format(42), x, y, z, f);
          break;
        default:
          writeBlock(gMotionModal.format(1), gFormat.format(40), x, y, z, f);
      }
    } else {
      writeBlock(gMotionModal.format(1), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      feedOutput.reset(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    return;
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);
  writeBlock(gMotionModal.format(0), x, y, z, a, b, c);
  feedOutput.reset();
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);
  var f = feedOutput.format(feed);
  if (x || y || z || a || b || c) {
    writeBlock(gMotionModal.format(1), x, y, z, a, b, c, f);
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      feedOutput.reset(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  var start = getCurrentPosition();

  if (isFullCircle()) {
    if (properties.useRadius || isHelical()) { // radius mode does not support full arcs
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
      case PLANE_XY:
        writeBlock(gAbsIncModal.format(90), gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), feedOutput.format(feed));
        break;
      // case PLANE_ZX:
      // writeBlock(gAbsIncModal.format(90), gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), feedOutput.format(feed));
      // break;
      // case PLANE_YZ:
      // writeBlock(gAbsIncModal.format(90), gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), feedOutput.format(feed));
      // break;
      default:
        linearize(tolerance);
    }
  } else if (!properties.useRadius) {
    switch (getCircularPlane()) {
      case PLANE_XY:
        writeBlock(gAbsIncModal.format(90), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), feedOutput.format(feed));
        break;
      // case PLANE_ZX:
      // writeBlock(gAbsIncModal.format(90), gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), feedOutput.format(feed));
      // break;
      // case PLANE_YZ:
      // writeBlock(gAbsIncModal.format(90), gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), feedOutput.format(feed));
      // break;
      default:
        linearize(tolerance);
    }
  } else { // use radius mode
    var r = getCircularRadius();
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      r = -r; // allow up to <360 deg arcs
    }
    switch (getCircularPlane()) {
      case PLANE_XY:
        writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), feedOutput.format(feed));
        break;
      // case PLANE_ZX:
      // writeBlock(gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), feedOutput.format(feed));
      // break;
      // case PLANE_YZ:
      // writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), feedOutput.format(feed));
      // break;
      default:
        linearize(tolerance);
    }
  }
}

var currentCoolantMode = undefined;
var coolantOff = undefined;

function setCoolant(coolant) {
  var coolantCodes = getCoolantCodes(coolant);
  if (Array.isArray(coolantCodes)) {
    for (var c in coolantCodes) {
      //writeBlock(coolantCodes[c]);
    }
    return undefined;
  }
  return coolantCodes;
}

function getCoolantCodes(coolant) {
  if (!coolants) {
    error(localize("Coolants have not been defined."));
  }
  if (!coolantOff) { // use the default coolant off command when an 'off' value is not specified for the previous coolant mode
    coolantOff = coolants.off;
  }

  if (isProbeOperation()) { // avoid coolant output for probing
    coolant = COOLANT_OFF;
  }

  if (coolant == currentCoolantMode) {
    return undefined; // coolant is already active
  }

  var multipleCoolantBlocks = new Array(); // create a formatted array to be passed into the outputted line
  if ((coolant != COOLANT_OFF) && (currentCoolantMode != COOLANT_OFF)) {
    multipleCoolantBlocks.push(mFormat.format(coolantOff));
  }

  var m;
  if (coolant == COOLANT_OFF) {
    m = coolantOff;
    coolantOff = coolants.off;
  }

  switch (coolant) {
    case COOLANT_FLOOD:
      if (!coolants.flood) {
        break;
      }
      m = coolants.flood.on;
      coolantOff = coolants.flood.off;
      break;
    case COOLANT_THROUGH_TOOL:
      if (!coolants.throughTool) {
        break;
      }
      m = coolants.throughTool.on;
      coolantOff = coolants.throughTool.off;
      break;
    case COOLANT_AIR:
      if (!coolants.air) {
        break;
      }
      m = coolants.air.on;
      coolantOff = coolants.air.off;
      break;
    case COOLANT_AIR_THROUGH_TOOL:
      if (!coolants.airThroughTool) {
        break;
      }
      m = coolants.airThroughTool.on;
      coolantOff = coolants.airThroughTool.off;
      break;
    case COOLANT_FLOOD_MIST:
      if (!coolants.floodMist) {
        break;
      }
      m = coolants.floodMist.on;
      coolantOff = coolants.floodMist.off;
      break;
    case COOLANT_MIST:
      if (!coolants.mist) {
        break;
      }
      m = coolants.mist.on;
      coolantOff = coolants.mist.off;
      break;
    case COOLANT_SUCTION:
      if (!coolants.suction) {
        break;
      }
      m = coolants.suction.on;
      coolantOff = coolants.suction.off;
      break;
    case COOLANT_FLOOD_THROUGH_TOOL:
      if (!coolants.floodThroughTool) {
        break;
      }
      m = coolants.floodThroughTool.on;
      coolantOff = coolants.floodThroughTool.off;
      break;
  }

  if (!m) {
    onUnsupportedCoolant(coolant);
    m = 9;
  }

  if (m) {
    if (Array.isArray(m)) {
      for (var i in m) {
        multipleCoolantBlocks.push(mFormat.format(m[i]));
      }
    } else {
      multipleCoolantBlocks.push(mFormat.format(m));
    }
    currentCoolantMode = coolant;
    return multipleCoolantBlocks; // return the single formatted coolant value
  }
  return undefined;
}

var mapCommand = {
  COMMAND_STOP: 0,
  COMMAND_END: 2,
  COMMAND_SPINDLE_CLOCKWISE: 3,
  COMMAND_SPINDLE_COUNTERCLOCKWISE: 4,
  COMMAND_STOP_SPINDLE: 5,
  COMMAND_LOAD_TOOL: 6
};

function onCommand(command) {
  switch (command) {
    case COMMAND_START_SPINDLE:
      onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
      return;
    case COMMAND_LOCK_MULTI_AXIS:
      return;
    case COMMAND_UNLOCK_MULTI_AXIS:
      return;
    case COMMAND_BREAK_CONTROL:
      return;
    case COMMAND_TOOL_MEASURE:
      return;
  }

  var stringId = getCommandStringId(command);
  var mcode = mapCommand[stringId];
  if (mcode != undefined) {
    //writeBlock(mFormat.format(mcode)); //This added an unwanted M1 to the code during tool changes.  Got rid of it.
  } else {
    onUnsupportedCommand(command);
  }
}

function onSectionEnd() {
  //writeBlock(gPlaneModal.format(17));

  if (((getCurrentSectionId() + 1) >= getNumberOfSections()) ||
    (tool.number != getNextSection().getTool().number)) {
    onCommand(COMMAND_BREAK_CONTROL);
  }

  forceAny();
}

/** Output block to do safe retract and/or move to home position. */
function writeRetract() {
  if (arguments.length == 0) {
    error(localize("No axis specified for writeRetract()."));
    return;
  }
  var words = []; // store all retracted axes in an array
  for (var i = 0; i < arguments.length; ++i) {
    let instances = 0; // checks for duplicate retract calls
    for (var j = 0; j < arguments.length; ++j) {
      if (arguments[i] == arguments[j]) {
        ++instances;
      }
    }
    if (instances > 1) { // error if there are multiple retract calls for the same axis
      error(localize("Cannot retract the same axis twice in one line"));
      return;
    }
    switch (arguments[i]) {
      case X:
        if (!machineConfiguration.hasHomePositionX()) {
          if (properties.useG28) {
            words.push("X" + xyzFormat.format(0));
          }
        } else {
          words.push("X" + xyzFormat.format(machineConfiguration.getHomePositionX()));
        }
        break;
      case Y:
        if (!machineConfiguration.hasHomePositionY()) {
          if (properties.useG28) {
            words.push("Y" + xyzFormat.format(208));
          }
        } else {
          words.push("Y" + xyzFormat.format(machineConfiguration.getHomePositionY()));
        }
        break;
      case Z:
        if (properties.useG28) {
          writeBlock(gFormat.format(28), gAbsIncModal.format(91), "Z" + xyzFormat.format(125));
          writeBlock(gAbsIncModal.format(90));
          zOutput.reset();
        }
        retracted = properties.useG28; // specifies that the tool has been retracted to the safe plane
        break;
      default:
        error(localize("Bad axis specified for writeRetract()."));
        return;
    }
  }
  if (words.length > 0) {
    gMotionModal.reset();
    if (properties.useG28) {
      gAbsIncModal.reset();
      writeBlock(gFormat.format(28), gAbsIncModal.format(91), words); // retract
      writeBlock(gAbsIncModal.format(90));
    } else {
      writeBlock(gAbsIncModal.format(90), gFormat.format(53), gMotionModal.format(0), words);
    }
  }
}

function onClose() {
  writeln("");

  // if (properties.useDustCollector) {
  // writeBlock(mFormat.format(9)); // turns off dust collector
  // } else {
  // setCoolant(COOLANT_OFF);
  // }

  writeRetract(Z);

  writeRetract(X, Y);

  setWorkPlane(new Vector(0, 0, 0)); // reset working plane

  onImpliedCommand(COMMAND_END);
  onImpliedCommand(COMMAND_STOP_SPINDLE);
  writeBlock(mFormat.format(5)); // stop program, spindle stop, coolant off
  writeBlock("T-1"); //any negative number unmounts all tools
  writeBlock(mFormat.format(0)); // stop program
}

function bCautious() {
  writeBlock(mFormat.format(291) + " P\"SAFETY FIRST! Ensure Tools are ready, Pneumatics are on and work piece is secure. Exercise extreme caution while machining.\" R\"CAUTION!\" S2");
  return;
}
