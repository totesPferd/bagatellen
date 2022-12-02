/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pel.INamedLiteral;
import dom.jfischer.probeunify2.pel.impl.NamedLiteral;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.pprint.IBackReference;
import dom.jfischer.probeunify2.pprint.IConstructionPPrint;
import dom.jfischer.probeunify2.pprint.IPPrintBase;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class LiteralLeafConstructionPPrint implements
        IConstructionPPrint {

    private final IBackReference backRef;
    private final IPELVariableContext pelVariableContext;
    private final IPELLeafCollector leafCollector;

    public LiteralLeafConstructionPPrint(IBackReference backRef, IPELVariableContext pelVariableContext, IPELLeafCollector leafCollector) {
        this.backRef = backRef;
        this.pelVariableContext = pelVariableContext;
        this.leafCollector = leafCollector;
    }

    @Override
    public String getSingleLine() {
        List<IVariable<ILiteralNonVariableExtension>> leafs = this.getLeafs();
        List<String> leafStanzas
                = Collections.synchronizedList(new ArrayList<>());
        for (IVariable<ILiteralNonVariableExtension> leaf : leafs) {
            String variableString = this.getVariableString(leaf);
            IBaseExpression<ILiteralNonVariableExtension> leafValue
                    = leaf.value().get();
            INamedLiteral nleaf = new NamedLiteral(leafValue, this.pelVariableContext);
            IConstructionPPrint literalConstructionPPrint
                    = new LiteralConstructionPPrint(
                            this.backRef,
                            nleaf);
            leafStanzas.add(variableString + " := " + literalConstructionPPrint.getSingleLine());
        }
        return "{ " + String.join(", ", leafStanzas) + " }";
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        pprintBase.printOpeningParenthesis("{");
        List<IVariable<ILiteralNonVariableExtension>> leafs
                = this.getLeafs();
        for (int i = 0; i < leafs.size(); i++) {
            IVariable<ILiteralNonVariableExtension> leaf = leafs.get(i);
            pprintBase.navigateToRelPos(0);
            if (i != 0) {
                pprintBase.printClosingParenthesis(",");
                pprintBase.printWhiteSpace(" ");
            }
            pprintBase.setDeeperIndent();
            pprintBase.navigateToRelPos(0);
            pprintBase.printToken(this.getVariableString(leaf));
            pprintBase.printAssignToken(":=");
            IBaseExpression<ILiteralNonVariableExtension> leafValue
                    = leaf.value().get();
            INamedLiteral nleaf = new NamedLiteral(leafValue, this.pelVariableContext);
            IConstructionPPrint leafConstructionPPrint
                    = new LiteralConstructionPPrint(
                            this.backRef,
                            nleaf);
            leafConstructionPPrint.pprint(pprintBase);
            pprintBase.restoreIndent();
        }
        pprintBase.forceWhiteSpace();
        pprintBase.printClosingParenthesis("}");
    }

    private List<IVariable<ILiteralNonVariableExtension>> getLeafs() {
        return Collections.synchronizedList(this.leafCollector.getLiteralLeafCollector().getLeafs()
                .parallelStream()
                .filter(v -> v.value().isPresent())
                .collect(Collectors.toList()));
    }

    private String getVariableString(IVariable<ILiteralNonVariableExtension> variable) {
        return "??" + this.pelVariableContext.getLiteralVariableContext().getName(variable);
    }

}
