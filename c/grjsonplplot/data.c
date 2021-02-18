#include <stdio.h>
#include <string.h>

#include "data.h"


int
grjsonplplot_data_parse_points(grjsonplplot_scale_option_t *p_scale_option, grjsonplplot_points_t *p_output, json_t *p_input) {
   int retval =  0;

   if (json_is_array(p_input)) {

      p_output->nr =  json_array_size(p_input);
      p_output->xdim =  (PLFLT *) malloc(sizeof(PLFLT[p_output->nr]));
      p_output->ydim =  (PLFLT *) malloc(sizeof(PLFLT[p_output->nr]));

      {
         size_t index;
         json_t *p_value;

         json_array_foreach(p_input, index, p_value) {
            if (json_is_object(p_value)) {
               json_t *p_x =  json_object_get(p_value, "x");
               json_t *p_y =  json_object_get(p_value, "y");

               if (p_x  && p_y) {
                  if (!json_is_real(p_x)) {
                     retval =  -1;
                     fputs("x dim in data item in stdin json must be real.\n", stderr);
                  }
                  if (!json_is_real(p_y)) {
                     retval =  -1;
                     fputs("y dim in data item in stdin json must be real.\n", stderr);
                  }
                  if (!retval) {
                     grjsonplplot_set_x(p_scale_option, p_output->xdim + index, (PLFLT) json_real_value(p_x));
                     grjsonplplot_set_y(p_scale_option, p_output->ydim + index, (PLFLT) json_real_value(p_y));
                  }
               } else {
                  retval =  -1;
                  if (!p_x) {
                     fputs("x dim in data item in stdin json missing.\n", stderr);
                  }
                  if (!p_y) {
                     fputs("y dim in data item in stdin json missing.\n", stderr);
                  }
               }
            } else {
               retval =  -1;
               fputs("data items in stdin json stream must be json objects.\n", stderr);
            }
         }
      }
   } else {
      retval =  -1;
      fputs("data in stdin json stream must be array\n", stderr);
   }

   return retval;
}

int
grjsonplplot_data_parse_xbars(grjsonplplot_scale_option_t *p_scale_option, grjsonplplot_xbars_t *p_output, json_t *p_input) {
   int retval =  0;

   if (json_is_array(p_input)) {

      p_output->nr =  json_array_size(p_input);
      p_output->xmin =  (PLFLT *) malloc(sizeof(PLFLT[p_output->nr]));
      p_output->xmax =  (PLFLT *) malloc(sizeof(PLFLT[p_output->nr]));
      p_output->ydim =  (PLFLT *) malloc(sizeof(PLFLT[p_output->nr]));

      {
         size_t index;
         json_t *p_value;

         json_array_foreach(p_input, index, p_value) {
            if (json_is_object(p_value)) {
               json_t *p_xmin =  json_object_get(p_value, "xmin");
               json_t *p_xmax =  json_object_get(p_value, "xmax");
               json_t *p_y =  json_object_get(p_value, "y");

               if (p_xmin && p_xmax && p_y) {
                  if (!json_is_real(p_xmin)) {
                     retval =  -1;
                     fputs("xmin dim in data item in stdin json must be real.\n", stderr);
                  }
                  if (!json_is_real(p_xmax)) {
                     retval =  -1;
                     fputs("xmax dim in data item in stdin json must be real.\n", stderr);
                  }
                  if (!json_is_real(p_y)) {
                     retval =  -1;
                     fputs("y dim in data item in stdin json must be real.\n", stderr);
                  }
                  if (!retval) {
                     grjsonplplot_set_x(p_scale_option, p_output->xmin + index, (PLFLT) json_real_value(p_xmin));
                     grjsonplplot_set_x(p_scale_option, p_output->xmax + index, (PLFLT) json_real_value(p_xmax));
                     grjsonplplot_set_y(p_scale_option, p_output->ydim + index, (PLFLT) json_real_value(p_y));
                  }
               } else {
                  retval =  -1;
                  if (!p_xmin) {
                     fputs("xmin dim in data item in stdin json missing.\n", stderr);
                  }
                  if (!p_xmax) {
                     fputs("xmax dim in data item in stdin json missing.\n", stderr);
                  }
                  if (!p_y) {
                     fputs("y dim in data item in stdin json missing.\n", stderr);
                  }
               }
            } else {
               retval =  -1;
               fputs("data items in stdin json stream must be json objects.\n", stderr);
            }
         }
      }
   } else {
      retval =  -1;
      fputs("data in stdin json stream must be array\n", stderr);
   }

   return retval;
}

int
grjsonplplot_data_parse_ybars(grjsonplplot_scale_option_t *p_scale_option, grjsonplplot_ybars_t *p_output, json_t *p_input) {
   int retval =  0;

   if (json_is_array(p_input)) {

      p_output->nr =  json_array_size(p_input);
      p_output->xdim =  (PLFLT *) malloc(sizeof(PLFLT[p_output->nr]));
      p_output->ymin =  (PLFLT *) malloc(sizeof(PLFLT[p_output->nr]));
      p_output->ymax =  (PLFLT *) malloc(sizeof(PLFLT[p_output->nr]));

      {
         size_t index;
         json_t *p_value;

         json_array_foreach(p_input, index, p_value) {
            if (json_is_object(p_value)) {
               json_t *p_x =  json_object_get(p_value, "x");
               json_t *p_ymin =  json_object_get(p_value, "ymin");
               json_t *p_ymax =  json_object_get(p_value, "ymax");

               if (p_x && p_ymin && p_ymax) {
                  if (!json_is_real(p_x)) {
                     retval =  -1;
                     fputs("x dim in data item in stdin json must be real.\n", stderr);
                  }
                  if (!json_is_real(p_ymin)) {
                     retval =  -1;
                     fputs("ymin dim in data item in stdin json must be real.\n", stderr);
                  }
                  if (!json_is_real(p_ymax)) {
                     retval =  -1;
                     fputs("ymax dim in data item in stdin json must be real.\n", stderr);
                  }
                  if (!retval) {
                     grjsonplplot_set_x(p_scale_option, p_output->xdim + index, (PLFLT) json_real_value(p_x));
                     grjsonplplot_set_y(p_scale_option, p_output->ymin + index, (PLFLT) json_real_value(p_ymin));
                     grjsonplplot_set_y(p_scale_option, p_output->ymax + index, (PLFLT) json_real_value(p_ymax));
                  }
               } else {
                  retval =  -1;
                  if (!p_x) {
                     fputs("x dim in data item in stdin json missing.\n", stderr);
                  }
                  if (!p_ymin) {
                     fputs("ymin dim in data item in stdin json missing.\n", stderr);
                  }
                  if (!p_ymax) {
                     fputs("ymax dim in data item in stdin json missing.\n", stderr);
                  }
               }
            } else {
               retval =  -1;
               fputs("data items in stdin json stream must be json objects.\n", stderr);
            }
         }
      }
   } else {
      retval =  -1;
      fputs("data in stdin json stream must be array\n", stderr);
   }

   return retval;
}

int
grjsonplplot_data_parse(grjsonplplot_scale_option_t *p_scale_option, json_t *p_input) {
   int retval =  0;

   if (json_is_object(p_input)) {
      json_t *p_type_data =  json_object_get(p_input, "type");
      json_t *p_data_data =  json_object_get(p_input, "data");
      if (!p_type_data) {
         retval = -1;
         fputs("curve item in json stdin stream must contain 'type' key.\n", stderr);
      } else if (!json_is_string(p_type_data)) {
         retval =  -1;
         fputs("a string must be assigned to 'type' key in curve item in json stdin stream.\n", stderr);
      }
      if (!p_data_data) {
         retval =  -1;
         fputs("curve item in json stdin stream must contain 'data' key.\n", stderr);
      }

      if (!retval) {
         const char *curve_type =  json_string_value(p_type_data);

         if (!strcmp(curve_type, "line")) {
            grjsonplplot_points_t output;
            if (grjsonplplot_data_parse_points(p_scale_option, &output, p_data_data)) {
               retval =  -1;
               fputs("data item related to curve item is misconstructed.\n", stderr);
            } else {
               plline(output.nr, output.xdim, output.ydim);
               free(output.xdim);
               free(output.ydim);
            }
         } else if (!strcmp(curve_type, "string")) {
            grjsonplplot_points_t output;
            json_t *p_string_data =  json_object_get(p_input, "string");
            if (!p_string_data) {
               retval =  -1;
               fputs("config item must contain 'string' key if you use 'type' 'string' in json stream on stdin.\n", stderr);
            } else if (grjsonplplot_data_parse_points(p_scale_option, &output, p_data_data)) {
               retval =  -1;
               fputs("data item related to curve item is misconstructed.\n", stderr);
            } else if (json_is_string(p_string_data)) {
               const char *curve_string =  json_string_value(p_string_data);
               plstring(output.nr, output.xdim, output.ydim, curve_string);
               free(output.xdim);
               free(output.ydim);
            } else {
               retval =  -1;
               fputs("'string' key must be assigned to a string in curve item.\n", stderr);
            }
         } else if (!strcmp(curve_type, "xbars")) {
            grjsonplplot_xbars_t output;
            if (grjsonplplot_data_parse_xbars(p_scale_option, &output, p_data_data)) {
               retval = -1;
               fputs("data item related to curve item is misconstructed.\n", stderr);
            } else {
               plerrx(output.nr, output.xmin, output.xmax, output.ydim);
               free(output.xmin);
               free(output.xmax);
               free(output.ydim);
            }
         } else if (!strcmp(curve_type, "ybars")) {
            grjsonplplot_ybars_t output;
            if (grjsonplplot_data_parse_ybars(p_scale_option, &output, p_data_data)) {
               retval = -1;
               fputs("data item related to curve item is misconstructed.\n", stderr);
            } else {
               plerry(output.nr, output.xdim, output.ymin, output.ymax);
               free(output.xdim);
               free(output.ymin);
               free(output.ymax);
            }
         } else {
            retval = -1;
            fprintf(stderr, "%s not admitted as curve type in curve item in json stdin stream.\n", curve_type);
         }
      }
   } else {
      retval = -1;
      fputs("curve item in json stdin stream must be a json object.\n", stderr);
   }

   return retval;
}

int
grjsonplplot_data_parse_array(grjsonplplot_scale_option_t *p_scale_option, json_t *p_input) {
   int retval =  0;

   if (!p_input) {
      retval =  -1;
      fputs("'data' key expected in json stream from stdin.\n", stderr);
   } else if (json_is_array(p_input)) {
      size_t index;
      json_t *p_value;
      json_array_foreach(p_input, index, p_value) {
         if (grjsonplplot_data_parse(p_scale_option, p_value)) {
            retval =  -1;
            fputs("matter assigned to 'data' key is misconstructed.\n", stderr);
         }
      }
   } else {
      retval =  -1;
      fputs("'data' key must be assigned to an array in json stream from stdin.\n", stderr);
   }

   return retval;
}
