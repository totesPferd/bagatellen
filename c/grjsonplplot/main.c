#include <jansson.h>
#include <plplot.h>
#include <stdio.h>

#include "configuration.h"
#include "data.h"
#include "options.h"

int
main(int argc, char **argv) {
   int retval =  0;

   grjsonplplot_scale_option_t scale_option;
   scale_option.xdim =  grjsonplplot_arithmetic;
   scale_option.ydim =  grjsonplplot_arithmetic;

   PLINT init_retcode =  plparseopts(&argc, argv, PL_PARSE_FULL);
   plinit();

   json_error_t json_error;
   json_t      *p_json_data =  json_loadf(stdin, JSON_REJECT_DUPLICATES, &json_error);
   if (p_json_data) {
      if (json_is_object(p_json_data)) {
         json_t *p_config_data =  json_object_get(p_json_data, "config");
	 retval =  grjsonplplot_config_parse(&scale_option, p_config_data);

	 json_t *p_data_data =  json_object_get(p_json_data, "data");
	 {
	    int retb =  grjsonplplot_data_parse_array(&scale_option, p_data_data);
	    retval =  retb ? retb : retval;
	 }
      } else {
	  retval =  -1;
          fputs("json object expected in stdin.\n", stderr);
      }
      json_decref(p_json_data);
   } else {
      fprintf(
            stderr
	 ,  "error in json stdin stream (%s) in %s, %d:%d (#%d)\n"
	 ,  json_error.text
	 ,  json_error.source
	 ,  json_error.line
	 ,  json_error.column
	 ,  json_error.position );
      retval =  -1;
   }

   plend();
   return retval;
}

