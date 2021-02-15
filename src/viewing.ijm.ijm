cropsize = 250;


for (i = 0; i < nImages; i++) {
	selectImage(i+1);
	makeRectangle((getWidth()-cropsize)/2,(getHeight()-cropsize)/2,cropsize,cropsize);
	run("Crop");
	setSlice(2);
	setMinAndMax(200, 700);
	run("Fire");
}
