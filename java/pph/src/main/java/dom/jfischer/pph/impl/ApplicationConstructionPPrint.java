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
public class ApplicationConstructionPPrint implements IConstructionPPrint {

    private final String operator;
    private final IConstructionPPrint argument;

    public ApplicationConstructionPPrint(String operator, IConstructionPPrint argument) {
        this.operator = operator;
        this.argument = argument;
    }

    @Override
    public String getSingleLine() {
        return this.operator + "(" + this.argument.getSingleLine() + ")";
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        pprintBase.printToken(this.operator);
        pprintBase.printOpeningParenthesis("(");
        this.argument.pprint(pprintBase);
        pprintBase.printClosingParenthesis(")");
    }

}
