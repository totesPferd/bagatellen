#include <assert.h>
#include <stdio.h>

#include "json.h"

static void
printErrMsgIntro(const grplot_json_schema_location_t *);

static void
printColorErrMsgIntro(const grplot_json_schema_location_t *, const char *);

static void
printFontErrMsgIntro(const grplot_json_schema_location_t *, const char *);

void
grplot_json_printErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  const char *text ) {
   assert(pLocation);
   assert(text);

   printErrMsgIntro(pLocation);
   fprintf(stderr, ": %s\n", text);
}

void
grplot_json_printColorErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  const char *colorDest
   ,  int errCode ) {
   assert(pLocation);
   assert(colorDest);

   if (errCode & grplot_json_error_red_integer) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "red component must be integer\n");
   }

   if (errCode & grplot_json_error_green_integer) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "green component must be integer\n");
   }

   if (errCode & grplot_json_error_blue_integer) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "blue component must be integer\n");
   }

   if (errCode & grplot_json_error_alpha_integer) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "alpha component must be integer\n");
   }

   if (errCode & grplot_json_error_red_range) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "red component: admitted range 0..255\n");
   }

   if (errCode & grplot_json_error_green_range) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "green component: admitted range 0..255\n");
   }

   if (errCode & grplot_json_error_blue_range) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "blue component: admitted range 0.255\n");
   }

   if (errCode & grplot_json_error_alpha_range) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "alpha component: admitted range 0.255\n");
   }
}

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

static void
printErrMsgIntro(
      const grplot_json_schema_location_t *pLocation ) {
   assert(pLocation);

   switch (pLocation->locationType) {

      case grplot_json_schema_base: {
         fprintf(stderr, "in base");
      }
      break;

      case grplot_json_schema_axis: {

         switch ((pLocation->variant).axis.axisType) {

            case grplot_axis_x_axis: {
               fprintf(stderr, "in x axis #%d", (pLocation->variant).axis.nr);
            }
            break;

            case grplot_axis_y_axis: {
               fprintf(stderr, "in y axis #%d", (pLocation->variant).axis.nr);
            }
            break;

            default: {
               assert(0);
            }
         }
      }
      break;

      case grplot_json_schema_diagram_base: {
         fprintf(stderr, "in diagram base #(%d, %d)"
            ,  (pLocation->variant).diagramBase.x
            ,  (pLocation->variant).diagramBase.y );
      }
      break;

      case grplot_json_schema_diagram: {
         fprintf(stderr, "in diagram #(%d, %d, %d)"
            ,  (pLocation->variant).diagram.base.x
            ,  (pLocation->variant).diagram.base.y
            ,  (pLocation->variant).diagram.nr );
      }
      break;

      default: {
         assert(0);
      }
   }
}

static void
printColorErrMsgIntro(
      const grplot_json_schema_location_t *pLocation
   ,  const char *dest ) {
   assert(pLocation);
   assert(dest);

   printErrMsgIntro(pLocation);
   fprintf(stderr, " (%s color): ", dest);
}

static void
printFontErrMsgIntro(
      const grplot_json_schema_location_t *pLocation
   ,  const char *dest ) {
   assert(pLocation);
   assert(dest);

   printErrMsgIntro(pLocation);
   fprintf(stderr, " (%s font): ", dest);
}
