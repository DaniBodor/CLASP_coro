cropsize = 250;
makeRectangle((getWidth()-cropsize)/2,(getHeight()-cropsize)/2,cropsize,cropsize);



setSlice(2);
run("Duplicate", " ");
mean = getValue("Mean");
stdev = getValue("StdDev");
Patchy_index = stdev/mean;		// larger index means more patchy (cutoff at 1?)
