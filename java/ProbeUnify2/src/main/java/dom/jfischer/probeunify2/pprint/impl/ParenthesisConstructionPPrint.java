/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.pprint.IConstructionPPrint;
import dom.jfischer.probeunify2.pprint.IPPrintBase;

/**
 *
 * @author jfischer
 */
public class ParenthesisConstructionPPrint implements IConstructionPPrint {

    private final String openingParenthesis;
    private final String closingParenthesis;
    private final IConstructionPPrint data;

    public ParenthesisConstructionPPrint(String openingParenthesis, String closingParenthesis, IConstructionPPrint data) {
        this.openingParenthesis = openingParenthesis;
        this.closingParenthesis = closingParenthesis;
        this.data = data;
    }

    @Override
    public String getSingleLine() {
        return this.openingParenthesis + this.data.getSingleLine() + this.closingParenthesis;
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        pprintBase.printOpeningParenthesis(this.openingParenthesis);
        this.data.pprint(pprintBase);
        pprintBase.printClosingParenthesis(this.closingParenthesis);
    }

}
