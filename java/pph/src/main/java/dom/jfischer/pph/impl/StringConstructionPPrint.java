/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.pph.impl;

import dom.jfischer.pph.IConstructionPPrint;
import dom.jfischer.pph.IPPrintBase;

/**
 *
 * @author jfischer
 */
public class StringConstructionPPrint implements IConstructionPPrint {

    private final String data;

    public StringConstructionPPrint(String data) {
        this.data = data;
    }

    @Override
    public String getSingleLine() {
        return this.data;
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        pprintBase.printToken(this.data);
    }

}
