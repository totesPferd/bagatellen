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
      fprintf(stderr, "red component: permitted range 0..255\n");
   }

   if (errCode & grplot_json_error_green_range) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "green component: permitted range 0..255\n");
   }

   if (errCode & grplot_json_error_blue_range) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "blue component: permitted range 0.255\n");
   }

   if (errCode & grplot_json_error_alpha_range) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "alpha component: permitted range 0.255\n");
   }

   if (errCode & grplot_json_error_color_object) {
      printColorErrMsgIntro(pLocation, colorDest);
      fprintf(stderr, "must be json object\n");
   }
}

void
grplot_json_printFontErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  const char *fontDest
   ,  int errCode ) {
   assert(pLocation);
   assert(fontDest);

   if (errCode & grplot_json_error_font_string) {
      printColorErrMsgIntro(pLocation, fontDest);
      fprintf(stderr, "must be json string\n");
   }
}

void
grplot_json_printAxisErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  grplot_axis_output_status_t status ) {
   assert(pLocation);

   switch (status) {

      case grplot_axis_output_ok:
      break;

      case grplot_axis_output_zero_range: {
         grplot_json_printErrMsg(
               pLocation
            ,  "max must be greater than min" );
      }
      break;

      case grplot_axis_output_time_overflow: {
         grplot_json_printErrMsg(
               pLocation
            ,  "no greater time interval available" );
      }
      break;

      case grplot_axis_output_inscription_buf_exceeded: {
         grplot_json_printErrMsg(
               pLocation
            ,  "too many inscriptions at axis" );
      }
      break;

      default: {
         assert(0);
      }
   }
}

void
grplot_json_printDiagramErrMsg(
      const grplot_json_schema_location_t *pLocation
   ,  grplot_diagram_status_t status ) {
   assert(pLocation);

   switch (status) {

      case grplot_diagram_ok:
      break;

      case grplot_diagram_empty_buf: {
         grplot_json_printErrMsg(
               pLocation
            ,  "empty input buf" );
      }
      break;

      case grplot_diagram_zero_range: {
         grplot_json_printErrMsg(
               pLocation
            ,  "max must be greater than min" );
      }
      break;

      default: {
         assert(0);
      }
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

int
grplot_json_font(json_t *pJson, const char **pResult) {
   int retval =  0;

   if (json_is_string(pJson)) {
      *pResult =  json_string_value(pJson);
   } else {
      retval |=  grplot_json_error_font_string;
   }

   return retval;
}

int
grplot_json_color_elem(
      const grplot_json_schema_location_t *pLocation
   ,  json_t *pJson
   ,  const char *dest
   ,  const DATA32 *pDefault
   ,  DATA32 *pOut ) {
   assert(pLocation);
   assert(dest);
   assert(pOut);

   if (pDefault) {
      *pOut =  *pDefault;
   }

   json_t *pElem =  json_object_get(pJson, "color");
   int errCode =  grplot_json_color(
         pJson
      ,  pOut );
   grplot_json_printColorErrMsg(pLocation, dest, errCode);

   return
         errCode
      ?  1
      :  0;
}

int
grplot_json_font_elem(
      const grplot_json_schema_location_t *pLocation
   ,  json_t *pJson
   ,  const char *dest
   ,  const Imlib_Font *pDefault
   ,  Imlib_Font *pOut ) {
   assert(pLocation);
   assert(dest);
   assert(pOut);

   if (pDefault) {
      *pOut =  *pDefault;
   }

   const char *fontName;
   json_t *pElem =  json_object_get(pJson, "font");
   int errCode =  grplot_json_font(
         pJson
      ,  &fontName );
   grplot_json_printFontErrMsg(pLocation, dest, errCode);

   int retval =  0;

   if (errCode) {
      retval =  1;
   } else {
      *pOut =  imlib_load_font(fontName);
      if (!pOut) {
         printFontErrMsgIntro(pLocation, dest);
         fprintf(stderr, " %s font could not be loaded.\n", fontName);
         retval =  1;
      }
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
