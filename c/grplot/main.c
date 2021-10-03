#include <jansson.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <Imlib2.h>

#include "axis_output.h"
#include "cmdline.h"
#include "input.h"
#include "json.h"
#include "matrix.h"
#include "report_imlib_load_error.h"

static int
cmdline_init(struct gengetopt_args_info *pArgsInfo, int argc, char **argv) {

   int retval =  0;

   if (cmdline_parser (argc, argv, pArgsInfo) != 0) {
      retval =  1 ;
   } else {
      struct cmdline_parser_params *params =  cmdline_parser_params_create();
      params->initialize =  0;
      params->override =  1;
      if (pArgsInfo->pfile_given && cmdline_parser_config_file(
            pArgsInfo->pfile_arg
         ,  pArgsInfo
         ,  params ) != 0) {
         retval =  2;
      }
   }

   return retval;
}

static int
cmdline_get_image_type(
      struct gengetopt_args_info *pArgsInfo
   ,  char **pResult) {
   int retval =  0;

   *pResult =  pArgsInfo->oformat_arg;
   if (!*pResult) {
      char *pFilename =  pArgsInfo->output_arg;
      char *pDot =  strrchr(pFilename, '.');
      if (pDot) pDot++;
      else retval =  1;
      *pResult =  pDot;
   }

   return retval;
}

static int
cmdline_font_path_init(
      struct gengetopt_args_info *pArgsInfo ) {

   for (unsigned i =  0; i < pArgsInfo->font_path_given; i++) {
      imlib_add_path_to_font_path(pArgsInfo->font_path_arg[i]);
   }

   return 0;
}

int
main(int argc, char **argv) {
   struct gengetopt_args_info args_info;
   int retval =  cmdline_init(&args_info, argc, argv);

   const char *outFilename =  args_info.output_arg;
   char *outImgFormat;
   cmdline_get_image_type(&args_info, &outImgFormat);

   const char *schemaFilename =  args_info.schema_arg;

   if (!retval) {
      cmdline_font_path_init(&args_info);
      grplot_matrix_t matrix;
      json_t *pJson;
      retval =  grplot_json_load(&matrix, &pJson, schemaFilename);
      if (!retval) {
         grplot_input_interpret(&matrix);
         grplot_matrix_prepare(&matrix);
      
         DATA32 *out_buf =  malloc (sizeof(DATA32) * (matrix.nrOutPixel));
         for (unsigned i =  0; i < matrix.nrOutPixel; i++) {
            out_buf[i] =  0xFF111111;
         }
   
         Imlib_Image image =  imlib_create_image_using_data(matrix.xTotal, matrix.yTotal, out_buf);
         imlib_context_set_image(image);
         imlib_image_set_format(outImgFormat);
      
         grplot_matrix_draw(&matrix, out_buf);
         grplot_matrix_destroy(&matrix);
   
         Imlib_Load_Error e = IMLIB_LOAD_ERROR_NONE;
         imlib_save_image_with_error_return(outFilename, &e);
         grplot_report_imlib_load_error("saving image: ", e);
      
         imlib_free_image();
         free(out_buf);

         json_decref(pJson);
      }
   }
   
   cmdline_parser_free (&args_info);

   return retval;
}
