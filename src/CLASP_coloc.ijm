BP_large = 20
BP_small = 3
BP_tol = 5
FM_prom = 5000



// split multi channel image into single channel images
ori = getTitle();
singleIMs(){
selectImage("CLASP");		clasp = getTitle();
selectImage("CENTROMERES");	cen = getTitle();
selectImage("CORONAS");		coro = getTitle();
selectImage("DAPI");		dna = getTitle();


// find spots in CLASP channel
roiManager("reset");
selectImage(clasp);	run("Duplicate...", " ");
BP = getTitle();
run("Bandpass Filter...", "filter_large="+BP_large+" filter_small="+BP_small+" suppress=None tolerance="+BP_tol+" autoscale");
run("Find Maxima...", "prominence="+FM_prom+" output=[Point Selection]");
roiManager("Add");
run("Find Maxima...", "prominence=5000 output=[Single Points]");
// CLASP signal gets value 100
run("Divide...","value=2.55");
clasp_points = getTitle();


// threshold CEN and CORO channels
selectImage(cen);	run("Duplicate...", " ");
bin_cen = getTitle();
setAutoThreshold("Yen dark");
run("Convert to Mask");
// CEN signal gets value 10
run("Divide...","value=25.5");

selectImage(coro);	run("Duplicate...", " ");
bin_coro = getTitle();
setAutoThreshold("Yen dark");
run("Convert to Mask");
// corona signal gets value 1
run("Divide...","value=255");

/*
 * Value reference:
 * 100 = CLASP only
 * 110 = CLASP + CEN
 * 101 = CLASP + Corona
 * 111 = CLASP + CEN + Corona
 */

imageCalculator("Add create", clasp_points,bin_cen);
sum = getTitle();
imageCalculator("Add", sum,bin_coro);

roiManager("measure");




function singleIMs(){
	selectImage(ori);
	setSlice(2);
	run("Duplicate...", "title=CLASP");
	resetMinAndMax;
	run("Fire");

	selectImage(ori);
	setSlice(3);
	run("Duplicate...", "title=CENTROMERES");
	resetMinAndMax;
	run("Fire");
		
	selectImage(ori)
	setSlice(1);
	run("Duplicate...", "title=CORONAS");
	resetMinAndMax;
	run("Fire");
	
	selectImage(ori)
	setSlice(4);
	run("Duplicate...", "title=DAPI");
	resetMinAndMax;
}	
	





