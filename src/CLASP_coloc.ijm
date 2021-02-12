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
 * Value reference & image color
 * (using the 'brgbcmyw' LUT @ (81,120) minmax):
 * 100 = CLASP only (blue)
 * 110 = CLASP + CEN (cyan)
 * 101 = CLASP + Corona (magenta)
 * 111 = CLASP + CEN + Corona (yellow)
 * 
 */

imageCalculator("Add create", clasp_points,bin_cen);
sum = getTitle();
imageCalculator("Add", sum,bin_coro);

IJ.deleteRows(0, nResults);
roiManager("measure");
out_array = Table.getColumn("Mean");

x = Array.filter(out_array, 111);	_111 = x.length;
x = Array.filter(out_array, 110);	_110 = x.length;
x = Array.filter(out_array, 101);	_101 = x.length;
x = Array.filter(out_array, 100);	_100 = x.length;

/*
A = 
_111 = out_array.length - Array.deleteValue(out_array, 111).length;
_110 = out_array.length - Array.deleteValue(out_array, 110).length;
_101 = out_array.length - Array.deleteValue(out_array, 101).length;
_100 = out_array.length - Array.deleteValue(out_array, 100).length;

_111 = Array.deleteValue(out_array, 111).length;
_111 = nResults - out_array.length;
Array.deleteValue(out_array, 110);
_110 = _111 - out_array.length;
Array.deleteValue(out_array, 101);
_101 = _110 - out_array.length;
_100 = out_array.length
*/

print(ori,nResults,_111,_110,_101,_100);



selectImage(1);
close("\\Others");


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
	





