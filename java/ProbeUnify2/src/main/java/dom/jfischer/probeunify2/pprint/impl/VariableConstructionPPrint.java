/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pprint.IConstructionPPrint;
import dom.jfischer.probeunify2.pprint.IPPrintBase;
import dom.jfischer.probeunify2.basic.IVariableContext;

/**
 *
 * @author jfischer
 * @param <Extension>
 * @param <NonVariableExtension>
 */
public class VariableConstructionPPrint<Extension extends IExtension, NonVariableExtension extends IExtension> implements
        IConstructionPPrint {

    private final String prefix;
    private final IVariableContext<Extension, NonVariableExtension> variableContext;
    private final IVariable<NonVariableExtension> variable;

    public VariableConstructionPPrint(String prefix, IVariableContext<Extension, NonVariableExtension> variableContext, IVariable<NonVariableExtension> variable) {
        this.prefix = prefix;
        this.variableContext = variableContext;
        this.variable = variable;
    }

    @Override
    public String getSingleLine() {
        String name = this.prefix + variableContext.getName(this.variable);
        IConstructionPPrint stringConstructionPPrint
                = new StringConstructionPPrint(name);
        return stringConstructionPPrint.getSingleLine();
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        String name = this.prefix + variableContext.getName(this.variable);
        IConstructionPPrint stringConstructionPPrint
                = new StringConstructionPPrint(name);
        stringConstructionPPrint.pprint(pprintBase);
    }

}
