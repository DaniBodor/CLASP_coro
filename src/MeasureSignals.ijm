////// parameter settings
// imaging channels
CORO_channel = 1;
CLASP_channel = 2;
CENPC_channel = 3;
DAPI_channel = 4;

spot_detection_channel = CENPC_channel;

// size of central region to analyze
cropsize = 250;	// in pixels

// Nuclear detection parameters
dapiDilateCycles = 4;
DAPI_maxSize = 20000;	// in px^2
DAPI_minSize = 2500;	// in px^2

// spot detection parameters
BPfilter_large = 3;		// bandpass filter
BPfilter_small = 2;		// bandpass filter
FM_prominence = 10000;	// find maxima

// Hoffmann circle sizes
analysis_circsize = 5;	// in pixels (use an uneven number)
bg_ringwidth = 1;		// in pixels



roiManager("reset");
print("\\Clear");
run("Clear Results");


// crop central region for analysis
oriIM = getTitle();
print(oriIM);
cropAnalysisRegion(cropsize);
cropIM = getTitle();
run("Properties...", "pixel_width=1 pixel_height=1");	Stack.setXUnit("px");	Stack.setYUnit("px");

// run through functions
getDNArea(cropIM, DAPI_channel);	// find nuclear outline from DAPI image
findSpots(cropIM, CLASP_channel);	// find spots in CLASP channels
measureAllChannels();

// determine intensity of 
analysis_circsize = 5;
for (i = 0; i < nResults; i++) {
	offset = (analysis_circsize-1)/2;
	x = getResult("X", i) - offset;
	y = getResult("Y", i) - offset;
	makeOval(x, y, analysis_circsize, analysis_circsize);
	
	roiManager("add");
	roiManager("select", roiManager("count")-1);
	roiManager("rename", "spot_"+i+1);
}




function cropAnalysisRegion(cropsize) {
	/*
	 * Crop central region for analysis
	 */
	makeRectangle((getWidth()-cropsize)/2,(getHeight()-cropsize)/2,cropsize,cropsize);
	run("Duplicate...", "title=cropped duplicate");
}


function getDNArea(image, channel) {
	/*
	 * Get outline of DAPI area using 'Minimum' threshold and dilation 
	 */
	selectImage(image);
	setSlice(channel);
	run("Duplicate...", "title=dapi");
	dapiIM=getTitle();
	
	setAutoThreshold("Minimum dark");
	run("Convert to Mask");
	for (i = 0; i < dapiDilateCycles; i++)		run("Dilate");
	run("Analyze Particles...", "size="+DAPI_minSize+"-"+DAPI_maxSize+" display exclude clear include add");
	if (roiManager("count") != 1)		waitForUser(roiManager("count") + " DAPI areas found");

	roiManager("select", roiManager("count")-1);
	roiManager("rename", "DAPI_area");
}

function findSpots(image, channel) {
	/*
	 * Find spots in channel using find maxima after bandpassing
	 */
	selectImage(image);
	setSlice(channel);
	resetMinAndMax();
	run("Duplicate...", "title=duplicate");
	dup=getTitle();
	
	run("Bandpass Filter...", "filter_large="+BPfilter_large+" filter_small="+BPfilter_small+" suppress=None tolerance=5 autoscale");
	roiManager("select", 0);

	run("Find Maxima...", "prominence="+FM_prominence+" output=List");
	
	
	offset = (analysis_circsize-1)/2;
	for (i = 0; i < nResults; i++) {
		x = getResult("X", i) - offset;
		y = getResult("Y", i) - offset;
		makeOval(x, y, analysis_circsize, analysis_circsize);
		
		roiManager("add");
		roiManager("select", roiManager("count")-1);
		roiManager("rename", "spot_"+i+1);
	}
}



function measureAllChannels() {
	selectImage(cropIM);
	for (roi = 1; roi < roiManager("count"); roi++) {

		signal_array = newArray(nSlices);
		signal_array[0] = roi;
		for (c = 1; c < nSlices; c++) {
			// measure specific signal
			roiManager("select", roi);
			setSlice(c);
			signal_array[c] = measureHoffmann(bg_ringwidth);
		}
		Array.print(signal_array);
	}
}

function measureHoffmann(ring) {
	innerDens = getValue("IntDen");
	innerArea = getValue("Area");
	innerMean = getValue("Mean");
	
	// make bg roi and measure signal
//	ring = 1;
	makeOval(getValue("BX")-ring, getValue("BY")-ring, getValue("Width")+(2*ring), getValue("Height")+(2*ring));
	outerDens = getValue("IntDen");
	outerArea = getValue("Area");
	
	// calculate bg corrected signal
	ringArea = outerArea - innerArea;
	ringDens = outerDens - innerDens;
	ringMean = ringDens/ringArea;
	
	specific_Signal = innerMean - ringMean;
	return specific_Signal;
}


