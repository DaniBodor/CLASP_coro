cropsize = 100;
print("\\Clear");

//data=getDirectory("Choose a Directory")
data = "C:\\Users\\dani\\Documents\\MyCodes\\CLASP_coro\\data\\raw"+File.separator;
//print(data);

print("IMname","Patchy_index","Patchy_index_bg","mean","stdev","min");
conditions = getFileList(data);
for (cond = 0; cond < conditions.length; cond++) {
	current_condition = conditions[cond];
	if ( File.isDirectory(data+current_condition) && !startsWith(current_condition,"test")){
		filelist = getFileList(data+current_condition);
		print(current_condition);
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
	makeRectangle((getWidth()-cropsize)/2,(getHeight()-cropsize)/2,cropsize,cropsize);
/*	setSlice(4);
	setAutoThreshold("Li dark");
	doWand(getWidth()/2, getHeight()/2);
	*/
	setSlice(2);
	run("Measure");
	area = getValue("Area");
	mean = getValue("Mean");
	stdev = getValue("StdDev");
	min = getValue("Min");
	Patchy_index = stdev/mean;		// larger index means more patchy (cutoff at 1?)
	Patchy_index_bg = stdev/(mean-min);		// larger index means more patchy (cutoff at 1?)
	IMprint = replace(IMname, " ", "");
	
	if (area<15)	small_area = "!!!";
	else 			small_area = "";
	
	print(IMprint,Patchy_index,Patchy_index_bg,mean,stdev,min);
	//waitForUser("vsdjkbcs");
}


