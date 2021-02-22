
DAPI_minarea = 50;
DAPI_maxarea = 250;
print("\\Clear");
run("Close All");
analysis_channel = 2;
dapi_channel = 4;
analysis_region = "bg";		// choose between bg, box, or dapi 
boxsize = 100;
N_bgfiles = 10;		// number of files to measure per condition for bg measures

//data=getDirectory("Choose a Directory")
data = "C:\\Users\\dani\\Documents\\MyCodes\\CLASP_coro\\data\\raw"+File.separator;
//print(data);

print("analysis channel number: "+analysis_channel);
print("IMname","Patchy_index","Patchy_index_bg","area","mean","stdev","min","skew","kurt");
conditions = getFileList(data);
for (cond = 0; cond < conditions.length; cond++) {
	current_condition = conditions[cond];
	if ( File.isDirectory(data+current_condition) && !startsWith(current_condition,"test")){
		filelist = getFileList(data+current_condition);
		print(current_condition);
		if (analysis_region == "bg" || analysis_region == "BG")		filelist = Array.trim(filelist, N_bgfiles);
		for (f = 0; f < filelist.length; f++) {
			IMname = filelist[f];
			if(indexOf(IMname, "_s1_")<0){
				open(data+current_condition+IMname);
				measurePatchindex();
				run("Close All");
			}
		}
	}
}






function measurePatchindex(){
	//cropsize=250;

	if (analysis_region == "box" || analysis_region == "BOX"){
		makeRectangle((getWidth()-boxsize)/2,(getHeight()-boxsize)/2,boxsize,boxsize);
	}
	else if (analysis_region == "bg" || analysis_region == "BG"){
		circsize = boxsize;	// * 1.5;
		makeOval((getWidth()-circsize)/2,(getHeight()-circsize)/2,circsize,circsize);
		setSlice(analysis_channel);
		resetMinAndMax();
		run("Fire");
		waitForUser("select bg region");
	}
	else if (analysis_region == "dapi" || analysis_region == "DAPI" || analysis_region == "Dapi"){
		setSlice(dapi_channel);
		setAutoThreshold("RenyiEntropy dark");
		//doWand(getWidth()/2, getHeight()/2);
		run("Analyze Particles...", "size="+DAPI_minarea+"-"+DAPI_maxarea+" show=Nothing display exclude clear include add slice");
	
		if(roiManager("count") != 1){
			waitForUser("ROIs found: "+roiManager("count"));
		}
	
		roiManager("select", 0);
	}


	setSlice(analysis_channel);
	run("Measure");
	area = getValue("Area");
	mean = getValue("Mean");
	stdev = getValue("StdDev");
	skew = getValue("Skew");
	kurt = getValue("Kurt");
	min = getValue("Min");
	Patchy_index = stdev/mean;		// larger index means more patchy (cutoff at 1?)
	Patchy_index_bg = stdev/(mean-min);		// larger index means more patchy (cutoff at 1?)
	IMprint = replace(IMname, " ", "");
	
//	if (area<15)	small_area = "!!!";
//	else 			small_area = "";
	
	print(IMprint,Patchy_index,Patchy_index_bg,area,mean,stdev,min,skew,kurt);
	//waitForUser("vsdjkbcs");
}


