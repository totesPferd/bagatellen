#include <stdio.h>

#include "configuration.h"
#include "options.h"

int
grjsonplplot_config_parse(grjsonplplot_scale_option_t *p_scale_option, json_t *p_input) {
        int retval =  0;

        if (!p_input) {
                retval =  -1;
                fputs("'config' key expected in json stream on stdin.\n", stderr);
        } else if (json_is_object(p_input)) {
                json_t *p_xmin =  json_object_get(p_input, "xmin");
                json_t *p_xmax =  json_object_get(p_input, "xmax");
                json_t *p_ymin =  json_object_get(p_input, "ymin");
                json_t *p_ymax =  json_object_get(p_input, "ymax");

                json_t *p_xlabel =  json_object_get(p_input, "xlabel");
                json_t *p_ylabel =  json_object_get(p_input, "ylabel");
                json_t *p_tlabel =  json_object_get(p_input, "tlabel");

                if (!p_xmin) {
                        retval =  -1;
                        fputs("config item in json stream on stdin must contain 'xmin' key.\n", stderr);
                } else if (!json_is_real(p_xmin)) {
                        retval =  -1;
                        fputs("'xmin' in config item in json stream on stdin must be assigned to real.\n", stderr);
                }
                if (!p_xmax) {
                        retval =  -1;
                        fputs("config item in json stream on stdin must contain 'xmax' key.\n", stderr);
                } else if (!json_is_real(p_xmax)) {
                        retval =  -1;
                        fputs("'xmax' in config item in json stream on stdin must be assigned to real.\n", stderr);
                }
                if (!p_ymin) {
                        retval =  -1;
                        fputs("config item in json stream on stdin must contain 'ymin' key.\n", stderr);
                } else if (!json_is_real(p_ymin)) {
                        retval =  -1;
                        fputs("'ymin' in config item in json stream on stdin must be assigned to real.\n", stderr);
                }
                if (!p_ymax) {
                        retval =  -1;
                        fputs("config item in json stream on stdin must contain 'ymax' key.\n", stderr);
                } else if (!json_is_real(p_xmax)) {
                        retval =  -1;
                        fputs("'ymax' in config item in json stream on stdin must be assigned to real.\n", stderr);
                }

                if (!p_xlabel) {
                        retval =  -1;
                        fputs("config item in json stream on stdin must contain 'xlabel' key.\n", stderr);
                } else if (!json_is_string(p_xlabel)) {
                        retval =  -1;
                        fputs("'xlabel' in config item in json stream on stdin must be assigned to string.\n", stderr);
                }
                if (!p_ylabel) {
                        retval =  -1;
                        fputs("config item in json stream on stdin must contain 'ylabel' key.\n", stderr);
                } else if (!json_is_string(p_ylabel)) {
                        retval =  -1;
                        fputs("'ylabel' in config item in json stream on stdin must be assigned to string.\n", stderr);
                }
                if (!p_tlabel) {
                        retval =  -1;
                        fputs("config item in json stream on stdin must contain 'tlabel' key.\n", stderr);
                } else if (!json_is_string(p_tlabel)) {
                        retval =  -1;
                        fputs("'tlabel' in config item in json stream on stdin must be assigned to string.\n", stderr);
                }

                if (!retval) {
                   json_t *p_xlog =  json_object_get(p_input, "xlog");
                   if (p_xlog) {
                           if (json_is_boolean(p_xlog)) {
                                   p_scale_option -> xdim =  json_boolean_value(p_xlog) ? grjsonplplot_logarithmic : grjsonplplot_arithmetic;
                           } else {
                                   retval =  -1;
                                   fputs("'xlog' key must be assigend to an boolean in config item in json stream on stdin.\n", stderr);
                           }
                   }

                   json_t *p_ylog =  json_object_get(p_input, "ylog");
                   if (p_ylog) {
                           if (json_is_boolean(p_ylog)) {
                                   p_scale_option -> ydim =  json_boolean_value(p_ylog) ? grjsonplplot_logarithmic : grjsonplplot_arithmetic;
                           } else {
                                   retval =  -1;
                                   fputs("'ylog' key must be assigend to an boolean in config item in json stream on stdin.\n", stderr);
                           }
                   }

                   {
                           PLFLT xmin, xmax, ymin, ymax;

                           grjsonplplot_set_x(p_scale_option, &xmin, (PLFLT) json_real_value(p_xmin));
                           grjsonplplot_set_x(p_scale_option, &xmax, (PLFLT) json_real_value(p_xmax));
                           grjsonplplot_set_y(p_scale_option, &ymin, (PLFLT) json_real_value(p_ymin));
                           grjsonplplot_set_y(p_scale_option, &ymax, (PLFLT) json_real_value(p_ymax));

                           int code =  3;

                           if (p_scale_option -> xdim == grjsonplplot_logarithmic) {
                                   code += 10;
                           }
                           if (p_scale_option -> ydim == grjsonplplot_logarithmic) {
                                   code += 20;
                           }

			   plwidth(0);
                           plenv(xmin, xmax, ymin, ymax, 0, code);
			   plwidth(5);
                   }

                   {
                           PLCHAR_VECTOR xlabel =  json_string_value(p_xlabel);
                           PLCHAR_VECTOR ylabel =  json_string_value(p_ylabel);
                           PLCHAR_VECTOR tlabel =  json_string_value(p_tlabel);

                           pllab(xlabel, ylabel, tlabel);
                   }
                }
        } else {
                retval = -1;
                fputs("'config' key in json stream on stdin must be assigned to json object.\n", stderr);
        }

        return retval;
}

