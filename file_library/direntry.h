#include <dirent.h>
#include <sys/stat.h>

const int IS_DIR_FLAG = 1, IS_FILE_FLAG = 2;

DIR *pdir;
struct dirent *next_entry;
struct stat statbuf;

int load_dir (char * path) {
	struct dirent *pent;
	struct stat statbuf;
	//Open current directory
	pdir = opendir(path);
	if (!pdir) {
		return 0; //Didn't open
	}
	return -1;
}

int has_next_entry () {
  next_entry = readdir(pdir);
  if (next_entry == NULL) return -1;
  
  stat(next_entry->d_name, &statbuf);
  return strlen(next_entry->d_name);
}

void get_next_entry (char * nam, int * flags, int * file_size) {
  strcpy(nam, next_entry->d_name);
  if (S_ISDIR(statbuf.st_mode)) {
    *flags = IS_DIR_FLAG;
  } else {
    *flags = IS_FILE_FLAG;
  }
  *file_size = statbuf.st_size;
  return ;
}

void close_dir () {
  closedir(pdir);
  pdir = NULL;
  return ;
}

