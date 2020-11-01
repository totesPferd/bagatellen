#ifndef CMDLINE_H
#define CMDLINE_H

/**
 *  @file cmdline.h
 *  interprets cmdline
 */

/**
 *  @brief parameters of an image file
 */
typedef struct {
  const char *filename; /**< complete filename of an image, e.g. image.png */
  const char *filetype; /**< image type, e.g. gif, jpeg, png */
} icor_fileinfo_t;

/**
 *  @brief respresentation of cmdline
 */
typedef struct {
  icor_fileinfo_t input;  /**< result of interpreting -i and --iformat option */
  icor_fileinfo_t output; /**< result of interpreting -o and --oformat option */
  long x;                 /**< result of interpreting -x option */
  long y;                 /**< result of interpreting -y option */
} icor_cmdline_t;

/**
 *  @brief evaluates cmdline args
 *  @param argc taken from argc arg of main function which must exist in each C
 * program
 *  @param argv taken from argv arg of main function which must exist in each C
 * program
 *  @param pCmdline structure which will contain cmdline data after finishing
 *  @return error code:
 *  *   0 ... no error
 *  *  -1 ... error; don't step in action; take cmdline as erroneous
 *  *  -2 ... help screen;  don't step in action but do not take cmdline as
 * erroneous
 */
int icor_cmdline_main(int argc, char **argv, icor_cmdline_t *pCmdline);

#endif
