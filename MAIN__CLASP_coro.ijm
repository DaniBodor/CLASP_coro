File.setDefaultDir ("C:\\Users\\dani\\Documents\\MyCodes\\CLASP_coro"+File.separator);
home = File.getDefaultDir
src = home+"src"+File.separator;
data = home+"data//raw"+File.separator;
output = home+"results"+File.separator;


cropsize = 250;

include_folder = "test";
exclude_folder = "";
conditions = getFileList(data);






// run macro on files
function openFiles(){
	for (cond = 0; cond < conditions.length; cond++) {
		if (cond == include_folder && cond != exclude_folder && endsWith(cond, File.separator)){
			curr_cond = data+cond+File.separator;
			flist = getFileList(curr_cond);
	
			for (f = 0; f < flist.length; f++) {
				file_path = curr_cond+flist[f];
				open(file_path)
			}
		}
	}
}



// select files to run macro on


makeRectangle((getWidth()-cropsize)/2,(getHeight()-cropsize)/2,cropsize,cropsize);


function multiArgument(arg1="",arg2="",arg3="",arg4="",arg5="",arg6="",arg7="",arg8="",arg9="",arg10=""){
	// generate single delimited argument from up to 10 separate arguments
	args = newArray(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10);
	separator="\t";
	newarg = ""
	for (i = 0; i < args.length; i++){
		if (args[i] != ""){
			newarg = newarg + args[i] + separator;
		}
		newarg = newarg + separator + "@@@";
	}
}

