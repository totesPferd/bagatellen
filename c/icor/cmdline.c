#include <assert.h>
#include <errno.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "cmdline.h"

static void
icor_init_fileinfo(icor_fileinfo_t *);

static void
icor_init_cmdline(icor_cmdline_t *);

static void
icor_set_filename(icor_fileinfo_t *, const char *);

static void
icor_set_filetype(icor_fileinfo_t *, const char *);

static void
print_help();

int
icor_cmdline_main(int argc, char **argv, icor_cmdline_t *pCmdline) {
   assert(argv);
   assert(pCmdline);

   int retval =  0;

   icor_init_cmdline(pCmdline);

   struct option long_options[] =  {
      { "help",    no_argument,       0, 'h' },
      { "input",   required_argument, 0, 'i' },
      { "iformat", required_argument, 0, 0 },
      { "output",  required_argument, 0, 'o' },
      { "oformat", required_argument, 0, 0 },
      { 0, 0, 0, 0 }
   };
   const char opt_string[] =  "hi:o:x:y:";

   int opt_idx;
   int opt;
   int is_iformat_specified =  0;
   int is_oformat_specified =  0;

   while ((opt =  getopt_long(argc, argv, opt_string, long_options, &opt_idx)) != -1) {

      switch (opt) {
      case 0:
         if (!strcmp(long_options[opt_idx].name, "iformat")) {
            if (is_iformat_specified) {
               retval =  -1;
               fputs("Use --iformat option only once!\n", stderr);
            } else {
               icor_set_filetype(&(pCmdline -> input), optarg);
               is_iformat_specified =  1;
            }
         } else
         if (!strcmp(long_options[opt_idx].name, "oformat")) {
            if (is_oformat_specified) {
               retval =  -1;
               fputs("Use --oformat option only once!\n", stderr);
            } else {
               icor_set_filetype(&(pCmdline -> output), optarg);
            }
         }
         break;
      case 'h':
         print_help();
         retval =  -2;
         break;
      case 'i':
         if ((pCmdline -> input).filename) {
            retval =  -1;
            fputs("Use -i/--input option only once!\n", stderr);
         } else {
            icor_set_filename(&(pCmdline -> input), optarg);
         }
         break;
      case 'o':
         if ((pCmdline -> output).filename) {
            retval =  -1;
            fputs("Use -o/--output option only once!\n", stderr);
         } else {
            icor_set_filename(&(pCmdline -> output), optarg);
         }
         break;
      case 'x': {
            char *pEnd;
            errno =  0;
            pCmdline -> x =  strtol(optarg, &pEnd, 10);
            if (errno) {
               retval =  -1;
               perror("opt param x");
            }
            if (*pEnd) {
               retval =  -1;
               fputs("Non-integer trash detected after integer in x cmdline param.\n", stderr); }}
         break;
      case 'y': {
            char *pEnd;
            errno =  0;
            pCmdline -> y =  strtol(optarg, &pEnd, 10);
            if (errno) {
               retval =  -1;
               perror("opt param y");
            }
            if (*pEnd) {
               retval =  -1;
               fputs("Non-integer trash detected after integer in y cmdline param.\n", stderr); }}
         break;
      default:
         retval =  -1;
         fputs("ill cmdline.\n", stderr);
      }

   };

   if (optind != argc) {
      retval =  -1;
      fputs("no non-option position param permitted on cmd line.\n", stderr);
   }
   if (retval != -2) {
      if (!(pCmdline -> input).filename) {
         retval =  -1;
         fputs("input filename missing.  Specify one with -i or --input option\n", stderr);
      } else
      if (!(pCmdline -> input).filetype) {
         retval =  -1;
         fputs("image type cannot be derived from input filename.  Specify on with --iformat option or use suitable input filename\n", stderr);
      }
      if (!(pCmdline -> output).filename) {
         retval =  -1;
         fputs("output filename missing.  Specify one with -o or --output option\n", stderr);
      } else
      if (!(pCmdline -> output).filetype) {
         retval =  -1;
         fputs("image type cannot be derived from output filename.  Specify on with --oformat option or use suitable output filename\n", stderr);
      }
      if (!(pCmdline -> x > 0)) {
         retval =  -1;
         fputs("x dim should be greater than 0.  Specify a x dim greater than 0 with -x option!\n", stderr);
      }
      if (!(pCmdline -> y > 0)) {
         retval =  -1;
         fputs("y dim should be greater than 0.  Specify a y dim greater than 0 with -y option!\n", stderr);
      }
   }

   return retval;
}

void
icor_init_fileinfo(icor_fileinfo_t *pFileinfo) {
   assert(pFileinfo);

   pFileinfo -> filename =  NULL;
   pFileinfo -> filetype =  NULL;
}

void
icor_init_cmdline(icor_cmdline_t *pCmdline) {
   assert(pCmdline);

   icor_init_fileinfo(&(pCmdline -> input));
   icor_init_fileinfo(&(pCmdline -> output));
   pCmdline -> x =  0;
   pCmdline -> y =  0;
}

void
icor_set_filename(icor_fileinfo_t *pFileinfo, const char *filename) {
   assert(pFileinfo);

   pFileinfo -> filename =  filename;
   if (!pFileinfo -> filetype) {
      icor_set_filetype(pFileinfo, strrchr(filename, '.') + 1);
   }
}

void
icor_set_filetype(icor_fileinfo_t *pFileinfo, const char *filetype) {
   assert(pFileinfo);

   pFileinfo -> filetype =  filetype;
}

void
print_help() {
   puts("");
   puts("Usage: icor <options>");
   puts("");
   puts("<options>:");
   puts("-i/--input  <filename> ... input filename (mandatory)");
   puts("-o/--output <filename> ... output filename (mandatory)");
   puts("--iformat <image type> ... input image type");
   puts("--oformat <image type> ... output image type");
   puts("-x <number>            ... #pixels in x dim");
   puts("-y <number>            ... #pixels in y dim"); 
   puts("-h/--help              ... print this help screen and exits immediately");
}
