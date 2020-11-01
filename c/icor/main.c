#include "cmdline.h"
#include "icor.h"

/**
 *  \mainpage icor -  convert and resize image files.
 *
 *  \section sample_usage Sample usage
 *
 *  	icor -i OriginalPhoto.jpg -o ProcessedPhoto.png -x 512 -y 768
 *
 *  convert a JPEG file OriginalPhoto.jpg into a PNG image file with aspects 512
 * x 768. It converts a JPEG file into a PNG file because OriginalPhoto.jpg ends
 * in .jpg and ProcessedPhoto.png ends in png.  If you want other image type use
 * --iformat or
 *  --oformat switch, respectively, e.g.
 *
 *  	icor -i Photo.jpg.orig --iformat jpg -o Photo.png.processed --oformat
 * png -x 512 -y 768
 *
 *  \attention `icor` does not preserve aspect ratio.
 *
 */

int main(int argc, char **argv) {
  int retval = 0;
  icor_cmdline_t cmdline;

  if (!(retval = icor_cmdline_main(argc, argv, &cmdline))) {

    retval = icor_main(&cmdline);

  } else {
    if (retval == -2)
      retval = 0; /* help screen. */
  }

  return retval;
}
