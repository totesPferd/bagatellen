#include <assert.h>
#include <fftw3.h>
#include <Imlib2.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "icor.h"

static int
icor_load_image(const icor_fileinfo_t *, Imlib_Image *);

static int
icor_save_image(const icor_fileinfo_t *, Imlib_Image *, DATA32 *, long, long);

static void
icor_report_imlib_load_error(const char *, Imlib_Load_Error);

static void
icor_convert_in_buf(const DATA32 *, double *, long, unsigned);

static void
icor_convert_out_buf(const double *, DATA32 *, long, unsigned, double);

static void
icor_transceive_buf(const double *, double *, long, long, long, long);

/*
 * Main procedure - do the job of icor.
 *
 * let imlib2 load and convert image from disk, then let fftw3 lib resize it and
 * in a last step let imlib2 store another image to disk.
 *
 *
 * Main procedure works as follows:
 *
 * Assume x_in and y_in are the aspect dimension of input image
 * and x_out and y_out are the one of the output image.
 *
 * We use 4 buffers:
 * * in_buf, representing a table x_in * y_in, into which the picture
 *   is loaded by imlib2,
 * * fftw_in_buf, representing a table x_in * y_in, which is used by fftw3,
 * * fftw_out_buf, representing a table x_out * y_out, which is used by
 *   fftw3 too,
 * * out_buf, representing a table x_out * y_out, from which imlib2
 *   saves picture to disk.
 * 
 * The following steps are performed by this procedure:
 * * loads picture into in_buf,
 * * for each of 4 channel a imlib2 supported picture is consisting in,
 *   R, G, B and A, do repeatedly the following tasks:
 *   + copy and convert respective 8bit data frm in_buf to double floating point
 *     content of fftw_in_buf,
 *   + apply DCT-III type fast fourier transformation in-place on these data,
 *   + transceive content of fftw_in_buf to fftw_out_buf.  Pad rows with 0.0
 *     on the right border if x_in < x_out or cut data on the right-hand side
 *     if x_in > x_out.  Pad 0.0 rows below the bottom if y_in < y_out or cut
 *     bottom rows if y_in > y_out,
 *   + apply DCT-II type fast fourier transformation in-place on fftw_out_buf,
 *   + copy, scale and convert double floating point content of fftw_out_buf
 *     into the respective channel 8bit data buffer from which imlib2 will store
 *     picture onto disk,
 * * saves picture from out_buf
 *
 */
int
icor_main(const icor_cmdline_t *pCmdline) {
   assert(pCmdline);
   assert((pCmdline->input).filename);
   assert((pCmdline->input).filetype);
   assert((pCmdline->output).filename);
   assert((pCmdline->output).filetype);

   int retval;

   Imlib_Image image;
   retval =  icor_load_image(&(pCmdline -> input), &image);

   if (!retval) {
      assert(image);

      const int x_in =  imlib_image_get_width();
      const int y_in =  imlib_image_get_height();
      const long no_pixels_in =  x_in * y_in;

      if (!no_pixels_in) {
         fputs("no pixels in input image.\n", stderr);
         imlib_free_image();
         retval =  -1;
      } else {

         double *fftw_in_buf =  fftw_alloc_real(no_pixels_in);
         fftw_plan plan_in =   fftw_plan_r2r_2d(y_in, x_in, fftw_in_buf, fftw_in_buf, FFTW_REDFT01, FFTW_REDFT01, FFTW_ESTIMATE);
   
         if (!plan_in) {
            fputs("It's programmer's fault:  FFTW routine could not generate plan in.  Contact him!\n", stderr);
            fftw_free(fftw_in_buf);
            imlib_free_image();
            retval =  -1;
         } else {
   
            const long no_pixels_out =  pCmdline -> x * pCmdline -> y;
            double *fftw_out_buf =  fftw_alloc_real(no_pixels_out);
            fftw_plan plan_out =  fftw_plan_r2r_2d(pCmdline -> y, pCmdline -> x, fftw_out_buf, fftw_out_buf, FFTW_REDFT10, FFTW_REDFT10, FFTW_ESTIMATE);
   
            if (!plan_out) {
               fputs("It's programmer's fault:  FFTW routine could not generate plan out.  Contact him!\n", stderr);
               fftw_free(fftw_in_buf);
               fftw_free(fftw_out_buf);
               fftw_destroy_plan(plan_in);
               imlib_free_image();
               retval =  -1;
            } else {
   
               const double scale =  0.25 / (double) no_pixels_in;
         
               DATA32 *in_buf =  imlib_image_get_data();
               DATA32 *out_buf =  malloc(sizeof(DATA32) * no_pixels_out);
         
               for (unsigned channel =  0; channel < 4; channel++) {

                  icor_convert_in_buf(in_buf, fftw_in_buf, no_pixels_in, channel);
                  fftw_execute(plan_in);
                  icor_transceive_buf(fftw_in_buf, fftw_out_buf, x_in, y_in, pCmdline -> x, pCmdline ->y);
                  fftw_execute(plan_out);
                  icor_convert_out_buf(fftw_out_buf, out_buf, no_pixels_out, channel, scale);

               }
         
               fftw_destroy_plan(plan_in);
               fftw_destroy_plan(plan_out);
               fftw_free(fftw_in_buf);
               fftw_free(fftw_out_buf);
               imlib_free_image();

               retval =  icor_save_image(&(pCmdline -> output), &image, out_buf, pCmdline -> x, pCmdline -> y);
               free(out_buf);
            }
         }
      }
   }

   return retval;
}

int
icor_load_image(const icor_fileinfo_t *pFileinfo, Imlib_Image *pImage) {
   assert(pFileinfo);
   assert(pFileinfo->filename);
   assert(pFileinfo->filetype);
   assert(pImage);

   int retval =  0;
   Imlib_Load_Error e =  IMLIB_LOAD_ERROR_NONE;

   *pImage =  imlib_load_image_with_error_return(pFileinfo->filename, &e);
   if (*pImage) {
      imlib_context_set_image(*pImage);
      imlib_image_set_format(pFileinfo->filetype);
   } else {
      icor_report_imlib_load_error("load image: ", e);
      retval =  -1;
   }

   return retval;
}

int
icor_save_image(const icor_fileinfo_t *pFileinfo, Imlib_Image *pImage, DATA32 *out_buf, long x_out, long y_out) {
   assert(pFileinfo);
   assert(pFileinfo->filename);
   assert(pFileinfo->filetype);
   assert(pImage);

   int retval =  0;

   *pImage =  imlib_create_image_using_data(x_out, y_out, out_buf);
   if (!*pImage) {
      fputs("It's programmer's fault: imlib denies providing structure for saving images\n", stderr);
      retval =  -1;
   } else {
      imlib_context_set_image(*pImage);
      imlib_image_set_format(pFileinfo->filetype);
      {
         Imlib_Load_Error e =  IMLIB_LOAD_ERROR_NONE;
         imlib_save_image_with_error_return(pFileinfo->filename, &e);
         if (e != IMLIB_LOAD_ERROR_NONE) {
            retval =  -1;
            icor_report_imlib_load_error("save image: ", e);
         }
      }
      imlib_free_image();
   }

   return retval;
}

void
icor_report_imlib_load_error(const char *prefix, Imlib_Load_Error e) {
   fputs(prefix, stderr);
   switch(e) {
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

void
icor_convert_in_buf(const DATA32 *in_buf, double *fftw_in_buf, long no_pixels_in, unsigned channel) {
   const DATA32 *in_pos =  in_buf;
   double *fftw_in_pos =  fftw_in_buf;
   for (long i =  0; i < no_pixels_in; i++) {
      unsigned char *vals =  (unsigned char *) in_pos;
      unsigned char val =  vals[channel];
      *fftw_in_pos =  (double) val;
      in_pos++;
      fftw_in_pos++;
   }
}

void
icor_convert_out_buf(const double *fftw_out_buf, DATA32 *out_buf, long no_pixels_out, unsigned channel, double scale) {
   DATA32 *out_pos =  out_buf;
   const double *fftw_out_pos =  fftw_out_buf;
   for (long i =  0; i < no_pixels_out; i++) {
      char *vals =  (char *) out_pos;
      int val =  floor(*fftw_out_pos * scale);
      if (val < 0) val =  0; else if (val > 255) val =  255;
      vals[channel] =  (char) val;
      out_pos++;
      fftw_out_pos++;
   }
}

void
icor_transceive_buf(const double *fftw_in_buf, double *fftw_out_buf, long x_in, long y_in, long x_out, long y_out) {
   const double *fftw_in_pos =   fftw_in_buf;
   double *fftw_out_pos =  fftw_out_buf;

   const long x_min =  x_in < x_out ? x_in : x_out;
   const long y_min =  y_in < y_out ? y_in : y_out;

   for (int i_y =  0; i_y < y_min; i_y++) {
      for (int i_x =  0; i_x < x_min; i_x++) {
         *fftw_out_pos =  *fftw_in_pos;
         fftw_in_pos++;
         fftw_out_pos++;
      }
      for (int i_x =  x_in; i_x < x_out; i_x++) {
         *fftw_out_pos =  0.0;
         fftw_out_pos++;
      }
      if (x_in > x_out) {
         fftw_in_pos += x_in - x_out;
      }
   }
   for (int i =  x_out * y_in; i < x_out * y_out; i++) {
      *fftw_out_pos =  0.0;
      fftw_out_pos++;
   }
}
