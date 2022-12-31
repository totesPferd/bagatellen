/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.pph.impl;

import dom.jfischer.pph.IConstructionPPrint;
import dom.jfischer.pph.IPPrintBase;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunifyfrontend1.names.IVariableNameInfo;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class VariableContextConstructionPPrint implements IConstructionPPrint {

    private final IVariableNameInfo variableNameInfo;
    private final IVariableContext<ITNonVariableXt> variableContext;

    public VariableContextConstructionPPrint(IVariableNameInfo variableNameInfo, IVariableContext<ITNonVariableXt> variableContext) {
        this.variableNameInfo = variableNameInfo;
        this.variableContext = variableContext;
    }

    @Override
    public String getSingleLine() {
        return "{ " + String.join(" ", this.getLeafNames()) + " }";
    }

    @Override
    public void pprintMultiLine(IPPrintBase ippb) {
        ippb.printOpeningParenthesis("{");
        ippb.setDeeperIndent();
        for (String variableName: this.getLeafNames()) {
            ippb.navigateToPos(0);
            ippb.printToken(variableName);
        }
        ippb.restoreIndent();
        ippb.printClosingParenthesis("}");
    }

    private List<String> getLeafNames() {
        return this.variableContext.getVariables()
                .parallelStream()
                .filter(var -> var.isLeaf())
                .map(var -> this.variableNameInfo.getName(var))
                .collect(Collectors.toList());
    }
}
