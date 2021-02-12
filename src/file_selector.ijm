// set data folder
//data = getDirectory("Set data folder");
import_args = getArgument();
args = split(import_args);


include_folder = args[0];
exclude_folder = args[1];
data = args[2];

conditions = getFileList(data);



for (cond = 0; cond < conditions.length; cond++) {
	if (cond == include_folder && cond != exclude_folder && endsWith(cond, File.separator)){
		curr_cond = data+cond+File.separator;

		flist = getFileList(curr_cond);
		file_path = curr_cond+flist[f];
		
		return file_path
		}
	}
}




