/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.pph.impl;

import dom.jfischer.pph.IConstructionPPrint;
import dom.jfischer.pph.IPPrintBase;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunifyfrontend1.names.ITermVariableInfo;
import dom.jfischer.probeunifyfrontend1.names.IVariableNameInfo;
import dom.jfischer.probeunifyfrontend1.pph.IBackReference;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class VarAssgnConstructionPPrint implements IConstructionPPrint {

    private final IVariableNameInfo variableNameInfo;
    private final ITermVariableInfo termVariableInfo;
    private final IBackReference backReference;
    private final IVariableContext<ITNonVariableXt> variableContext;

    public VarAssgnConstructionPPrint(IVariableNameInfo variableNameInfo, ITermVariableInfo termVariableInfo, IBackReference backReference, IVariableContext<ITNonVariableXt> variableContext) {
        this.variableNameInfo = variableNameInfo;
        this.termVariableInfo = termVariableInfo;
        this.backReference = backReference;
        this.variableContext = variableContext;
    }

    @Override
    public String getSingleLine() {
        List<String> assgnItems = this.getNonLeafs()
                .parallelStream()
                .map(var
                        -> this.getVariableName(var)
                + " := "
                + this.getVariableValueConstructionPPrint(var).getSingleLine())
                .collect(Collectors.toList());
        return "{ " + String.join(", ", assgnItems) + " }";
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        pprintBase.printOpeningParenthesis("{");
        List<IVariable<ITNonVariableXt>> nonLeafs
                = this.getNonLeafs();
        for (int i = 0; i < nonLeafs.size(); i++) {
            IVariable<ITNonVariableXt> nonLeaf = nonLeafs.get(i);
            pprintBase.navigateToRelPos(0);
            if (i != 0) {
                pprintBase.printClosingParenthesis(",");
                pprintBase.printWhiteSpace(" ");
            }
            pprintBase.setDeeperIndent();
            pprintBase.navigateToRelPos(0);
            pprintBase.printToken(this.getVariableName(nonLeaf));
            pprintBase.printAssignToken(":=");
            this.getVariableValueConstructionPPrint(nonLeaf).pprint(pprintBase);
            pprintBase.restoreIndent();
        }
        pprintBase.forceWhiteSpace();
        pprintBase.printClosingParenthesis("}");
    }

    private String getVariableName(IVariable<ITNonVariableXt> nonLeaf) {
        Map<IVariable<ITNonVariableXt>, IXpr<INonVariableXt>> sortsMap
                = this.termVariableInfo.getSorts();
        String retval = this.variableNameInfo.getName(nonLeaf);
        if (sortsMap.containsKey(nonLeaf)) {
            IXpr<INonVariableXt> sort
                    = sortsMap.get(nonLeaf);
            String sortName = this.backReference.getSortRef().get(sort);
            retval += ":" + sortName;
        }
        return retval;
    }

    private IConstructionPPrint getVariableValueConstructionPPrint(IVariable<ITNonVariableXt> nonLeaf) {
        IXpr<ITNonVariableXt> dereferencedNonLeaf
                = nonLeaf.dereference();
        return new XprConstructionPPrint(
                this.variableNameInfo,
                this.backReference,
                dereferencedNonLeaf
        );
    }

    private List<IVariable<ITNonVariableXt>> getNonLeafs() {
        return this.variableContext.getVariables()
                .parallelStream()
                .filter(var -> !var.isLeaf())
                .collect(Collectors.toList());
    }

}
