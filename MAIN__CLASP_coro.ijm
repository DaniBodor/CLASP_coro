File.setDefaultDir ("C:\\Users\\dani\\Documents\\MyCodes\\CLASP_coro"+File.separator);
home = File.getDefaultDir
src = home+"src"+File.separator;
data = home+"data//raw"+File.separator;
output = home+"results"+File.separator;


cropsize = 250;


// select files to run macro on
include_folder = "test";
exclude_folder = "";
file_selector_argument = MultiArgument(include_folder,exclude_folder,data);
runMacro(src + "file_selector.ijm",file_selector_argument);


makeRectangle((getWidth()-cropsize)/2,(getHeight()-cropsize)/2,cropsize,cropsize);


function MultiArgument(arg1="",arg2="",arg3="",arg4="",arg5="",arg6="",arg7="",arg8="",arg9="",arg10=""){
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

