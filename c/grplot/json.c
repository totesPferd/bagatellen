#include <assert.h>

#include "json.h"

int
grplot_json_color(json_t *pJson, DATA32 *pResult) {
   int retval =  0;

   *pResult =  0;

   if (json_is_object(pJson)) {
      {
         json_t *pRed =  json_object_get(pJson, "r");
         if (json_is_integer(pRed)) {
            int red =  json_integer_value(pRed);
            if (red >= 0 && red < 256) {
               ((unsigned char *) pResult)[2] =  red;
            } else {
               retval |=   grplot_json_error_red_range;
            }
         } else {
            retval |=   grplot_json_error_red_integer;
         }
      }
      {
         json_t *pGreen =  json_object_get(pJson, "g");
         if (json_is_integer(pGreen)) {
            int green =  json_integer_value(pGreen);
            if (green >= 0 && green < 256) {
               ((unsigned char *) pResult)[1] =  green;
            } else {
               retval |=   grplot_json_error_green_range;;
            }
         } else {
            retval |=   grplot_json_error_green_integer;
         }
      }
      {
         json_t *pBlue =  json_object_get(pJson, "b");
         if (json_is_integer(pBlue)) {
            int blue =  json_integer_value(pBlue);
            if (blue >= 0 && blue < 256) {
               ((unsigned char *) pResult)[0] =  blue;
            } else {
               retval |=   grplot_json_error_blue_range;
            }
         } else {
            retval |=   grplot_json_error_blue_integer;
         }
      }
      {
         json_t *pAlpha =  json_object_get(pJson, "a");
         if (json_is_integer(pAlpha)) {
            int alpha =  json_integer_value(pAlpha);
            if (alpha >= 0 && alpha < 256) {
               ((unsigned char *) pResult)[3] =  alpha;
            } else {
               retval |=   grplot_json_error_alpha_range;
            }
         } else {
            retval |=   grplot_json_error_alpha_integer;
         }
      }
   } else {
      retval |=  grplot_json_error_color_object;
   }

   return retval;
}
