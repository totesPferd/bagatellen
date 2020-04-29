#ifndef ICOR_H
#define ICOR_H

/**
 *  @file icor.h
 *  doing the job of icor program
 */

#include "cmdline.h"

/**
 *  @brief Main procedure which does the job of icor.
 *
 *  @param pCmdline interpreted cmdline params
 *  @return exit code of icor
 */
int
icor_main(const icor_cmdline_t *pCmdline);

#endif
