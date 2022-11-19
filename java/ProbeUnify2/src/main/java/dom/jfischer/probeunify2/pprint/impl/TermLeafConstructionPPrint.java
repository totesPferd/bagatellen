/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pprint.IBackReference;
import dom.jfischer.probeunify2.pprint.IConstructionPPrint;
import dom.jfischer.probeunify2.pprint.IPPrintBase;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class TermLeafConstructionPPrint implements IConstructionPPrint {

    private final IBackReference backRef;
    private final ITermVariableContext termVariableContext;
    private final IPELLeafCollector leafCollector;

    public TermLeafConstructionPPrint(IBackReference backRef, ITermVariableContext termVariableContext, IPELLeafCollector leafCollector) {
        this.backRef = backRef;
        this.termVariableContext = termVariableContext;
        this.leafCollector = leafCollector;
    }

    @Override
    public String getSingleLine() {
        List<IVariable<ITermNonVariableExtension>> leafs = this.getLeafs();
        List<String> leafStanzas
                = Collections.synchronizedList(new ArrayList<>());
        for (IVariable<ITermNonVariableExtension> leaf : leafs) {
            String variableString = this.getVariableString(leaf);
            IBaseExpression<ITermNonVariableExtension> leafValue
                    = leaf.value().get();
            IConstructionPPrint termConstructionPPrint
                    = new TermBaseConstructionPPrint(
                            this.backRef,
                            this.termVariableContext,
                            leafValue);
            leafStanzas.add(variableString + " := " + termConstructionPPrint.getSingleLine());
        }
        return "{ " + String.join(", ", leafStanzas) + " }";
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        pprintBase.printOpeningParenthesis("{");
        List<IVariable<ITermNonVariableExtension>> leafs
                = this.getLeafs();
        for (int i = 0; i < leafs.size(); i++) {
            IVariable<ITermNonVariableExtension> leaf = leafs.get(i);
            pprintBase.navigateToRelPos(0);
            if (i != 0) {
                pprintBase.printClosingParenthesis(",");
                pprintBase.printWhiteSpace(" ");
            }
            pprintBase.setDeeperIndent();
            pprintBase.navigateToRelPos(0);
            pprintBase.printToken(this.getVariableString(leaf));
            pprintBase.printAssignToken(":=");
            IConstructionPPrint leafConstructionPPrint
                    = new TermBaseConstructionPPrint(
                            this.backRef,
                            this.termVariableContext,
                            leaf.value().get());
            leafConstructionPPrint.pprint(pprintBase);
            pprintBase.restoreIndent();
        }
        pprintBase.forceWhiteSpace();
        pprintBase.printClosingParenthesis("}");
    }

    private List<IVariable<ITermNonVariableExtension>> getLeafs() {
        return Collections.synchronizedList(this.leafCollector.getTermLeafCollector().getLeafs()
                .parallelStream()
                .filter(v -> v.value().isPresent())
                .collect(Collectors.toList()));
    }

    private String getVariableString(IVariable<ITermNonVariableExtension> variable) {
        String name = this.termVariableContext.getName(variable);
        IBaseExpression<ITrivialExtension> sort = this.termVariableContext.getSortMap().get(variable);
        String sortName = this.backRef.getSortRef().get(sort);
        return name + ":" + sortName;
    }

}
