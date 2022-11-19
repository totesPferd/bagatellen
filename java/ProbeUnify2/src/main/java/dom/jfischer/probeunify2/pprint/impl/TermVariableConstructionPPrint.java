/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pprint.IConstructionPPrint;
import dom.jfischer.probeunify2.pprint.IPPrintBase;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;

/**
 *
 * @author jfischer
 */
public class TermVariableConstructionPPrint implements IConstructionPPrint {

    private final ITermVariableContext termVariableContext;
    private final IVariable<ITermNonVariableExtension> variable;

    public TermVariableConstructionPPrint(ITermVariableContext termVariableContext, IVariable<ITermNonVariableExtension> variable) {
        this.termVariableContext = termVariableContext;
        this.variable = variable;
    }

    @Override
    public String getSingleLine() {
        String name = termVariableContext.getName(this.variable);
        IConstructionPPrint stringConstructionPPrint
                = new StringConstructionPPrint(name);
        return stringConstructionPPrint.getSingleLine();
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        String name = termVariableContext.getName(this.variable);
        IConstructionPPrint stringConstructionPPrint
                = new StringConstructionPPrint(name);
        stringConstructionPPrint.pprint(pprintBase);
    }

}
