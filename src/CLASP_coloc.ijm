ori = getTitle();

// split multi channel image into single channel images
singleIMs(){
selectImage("CLASP");		clasp = getTitle();
selectImage("CENTROMERES");	cen = getTitle();
selectImage("CORONAS");		coro = getTitle();
selectImage("DAPI");		dna = getTitle();





function singleIMs(){
	selectImage(ori);
	setSlice(2);
	run("Duplicate", "CLASP");

	selectImage(ori);
	setSlice(3);
	run("Duplicate", "CENTROMERES");
	
	selectImage(ori)
	setSlice(1);
	run("Duplicate", "CORONAS");

	selectImage(ori)
	setSlice(4);
	run("Duplicate", "DAPI");

}	
	





