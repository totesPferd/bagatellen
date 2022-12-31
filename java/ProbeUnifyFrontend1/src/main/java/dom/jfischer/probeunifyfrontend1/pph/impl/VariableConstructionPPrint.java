/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.pph.impl;

import dom.jfischer.pph.IConstructionPPrint;
import dom.jfischer.pph.IPPrintBase;
import dom.jfischer.pph.impl.StringConstructionPPrint;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunifyfrontend1.names.IVariableNameInfo;

/**
 *
 * @author jfischer
 */
public class VariableConstructionPPrint implements IConstructionPPrint {

    private final IVariableNameInfo variableNameInfo;
    private final IVariable<ITNonVariableXt> variable;

    public VariableConstructionPPrint(IVariableNameInfo variableNameInfo, IVariable<ITNonVariableXt> variable) {
        this.variableNameInfo = variableNameInfo;
        this.variable = variable;
    }

    @Override
    public String getSingleLine() {
        String name = this.variableNameInfo.getName(this.variable);
        IConstructionPPrint constructionPPrint
                = new StringConstructionPPrint(name);
        return constructionPPrint.getSingleLine();
    }

    @Override
    public void pprintMultiLine(IPPrintBase ippb) {
        String name = this.variableNameInfo.getName(this.variable);
        IConstructionPPrint constructionPPrint
                = new StringConstructionPPrint(name);
        constructionPPrint.pprint(ippb);
    }

}
