function coefficientSimplicity() {
    var cSimplicity, exists, i, j, intersects, lines, objCmdStr, objName;

    cSimplicity = 0;
    intersects = [];
    lines = [];

    for (i = 0; i < ggbApplet.getObjectNumber(); i++) {
	objName = ggbApplet.getObjectName(i);
	objCmdStr = ggbApplet.getCommandString(objName, 0);
	switch (ggbApplet.getObjectType(objName)) {
	case "circle":
	    if ((objCmdStr.match(/,/g)).length == 2) {
		cSimplicity+=3;
	    } else {
		cSimplicity+=2;
	    }
	    break;
	case "line":
	    if (!objCmdStr.match(/,/g)) {
		cSimplicity++;
	    } else {
		if ((objCmdStr.match(/,/g)).length == 2) {
		    cSimplicity+=3;
		} else {
		    exists = false;
		    j = 0;
		    while ((!exists) && (j < lines.length)) {
			exists = lines[j] == objCmdStr;
			j++;
		    }
		    if (!exists) {
			lines.push(objCmdStr);
			cSimplicity+=2;
		    }
		}
	    }
	    break;
	case "point":
	    if (ggbApplet.isIndependent(objName)) {
		cSimplicity++;
	    } else {
		if (objCmdStr.startsWith("Intersect")) {
		    exists = false;
		    j = 0;
		    while ((!exists) && (j < intersects.length)) {
			exists = intersects[j] == objCmdStr;
			j++;
		    }
		    if (!exists) {
			intersects.push(objCmdStr);
			if ((objCmdStr.match(/,/g)).length == 2) {
			    cSimplicity++;
			} else {
			    cSimplicity+=2;
			}
		    }
		}
		if (objCmdStr.startsWith("Midpoint")) {
		    if (objCmdStr.match(/,/g)) {
			cSimplicity+=2;
		    } else {
			cSimplicity++;
		    }
		}
		if (objCmdStr.startsWith("Point")) {
		    cSimplicity++;
		}
	    }
	    break;
	case "ray":
	    cSimplicity+=2;
	    break;
	case "segment":
	    cSimplicity+=2;
	    break;
	default:
	    // Other types of objects are ignored
	}
    }
    return cSimplicity;
} // coefficientSimplicity


function coefficientFreedom() {
    var cFreedom, i, objName;

    cFreedom = 0;

    for (i = 0; i < ggbApplet.getObjectNumber(); i++) {
	objName = ggbApplet.getObjectName(i);
	if (ggbApplet.getObjectType(objName) == "point") {
	    if (ggbApplet.isIndependent(objName)) {
		cFreedom+=2;
	    } else if (ggbApplet.getCommandString(objName, 0).startsWith("Point")) {
		    cFreedom++;
	    }
	}
    }
    
    return cFreedom;
} // coeficientFreedom

function geometrography() {
    ggbApplet.evalCommand("Geometrography = {" + coefficientSimplicity()
			  + "," + coefficientFreedom() + "}");
} // geometrography


function ggbOnInit() {
    ggbApplet.evalCommand("Geometrography = {" + coefficientSimplicity()
			  + "," + coefficientFreedom() + "}");
    
    ggbApplet.registerAddListener("geometrography");
    ggbApplet.registerRemoveListener("geometrography");
} // ggbOnInit
