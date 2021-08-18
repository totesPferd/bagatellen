#include <stdio.h>

#include "report_imlib_load_error.h"

void grplot_report_imlib_load_error(const char *prefix, Imlib_Load_Error e) {
  fputs(prefix, stderr);
  switch (e) {
  case IMLIB_LOAD_ERROR_NONE:
    fputs("ok\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_FILE_DOES_NOT_EXIST:
    fputs("file does not exist\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_FILE_IS_DIRECTORY:
    fputs("file is directory\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_PERMISSION_DENIED_TO_READ:
    fputs("no read permission\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_NO_LOADER_FOR_FILE_FORMAT:
    fputs("no loader for file format\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_PATH_TOO_LONG:
    fputs("path too long\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_PATH_COMPONENT_NON_EXISTANT:
    fputs("path component does not exist\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_PATH_COMPONENT_NOT_DIRECTORY:
    fputs("path component is not directory\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_PATH_POINTS_OUTSIDE_ADDRESS_SPACE:
    fputs("path points outside address space\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_TOO_MANY_SYMBOLIC_LINKS:
    fputs("too many symbolic links\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_OUT_OF_MEMORY:
    fputs("out of memory\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_OUT_OF_FILE_DESCRIPTORS:
    fputs("load error out of file descriptors\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_PERMISSION_DENIED_TO_WRITE:
    fputs("no write permission\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_OUT_OF_DISK_SPACE:
    fputs("out of disk space\n", stderr);
    break;
  case IMLIB_LOAD_ERROR_UNKNOWN:
    fputs("unknown problem\n", stderr);
    break;
  default:
    fputs("WTF???\n", stderr);
    break;
  }
}

