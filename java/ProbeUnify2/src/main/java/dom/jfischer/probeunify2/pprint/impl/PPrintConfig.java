/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.pprint.IPPrintConfig;

/**
 *
 * @author jfischer
 */
public class PPrintConfig implements IPPrintConfig {

    private final int indent = 3;
    private final int pageWidth = 72;

    @Override
    public int getIndent() {
        return this.indent;
    }

    @Override
    public int getPageWidth() {
        return this.pageWidth;
    }

}
