/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.pel.INamedLiteral;
import dom.jfischer.probeunify2.pel.impl.NamedLiteral;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.pprint.IBackReference;
import dom.jfischer.probeunify2.pprint.IConstructionPPrint;
import dom.jfischer.probeunify2.pprint.IPPrintBase;
import dom.jfischer.probeunify2.proof.IClause;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class ClauseConstructionPPrint implements IConstructionPPrint {

    private final IBackReference backRef;
    private final INamedClause namedClause;

    public ClauseConstructionPPrint(IBackReference backRef, INamedClause clause) {
        this.backRef = backRef;
        this.namedClause = clause;
    }

    @Override
    public String getSingleLine() {
        IClause clause = this.namedClause.getClause();
        IPELVariableContext pelVariableContext
                = this.namedClause.getPelVariableContext();
        IBaseExpression<ILiteralNonVariableExtension> conclusion = clause.getConclusion();
        List<IBaseExpression<ILiteralNonVariableExtension>> premises = clause.getPremises();
        INamedLiteral namedConclusion = new NamedLiteral(conclusion, pelVariableContext);
        IConstructionPPrint conclusionConstructionPPrint
                = new LiteralConstructionPPrint(this.backRef, namedConclusion);
        List<String> premiseStringList
                = Collections.synchronizedList(premises
                        .parallelStream()
                        .map(premise -> new NamedLiteral(premise, pelVariableContext))
                        .map(npremise -> new LiteralConstructionPPrint(this.backRef, npremise))
                        .map(pc -> pc.getSingleLine())
                        .collect(Collectors.toList()));

        return String.join("; ", premiseStringList) + " ==> " + conclusionConstructionPPrint.getSingleLine();
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        IClause clause = this.namedClause.getClause();
        IPELVariableContext pelVariableContext
                = this.namedClause.getPelVariableContext();
        IBaseExpression<ILiteralNonVariableExtension> conclusion = clause.getConclusion();
        List<IBaseExpression<ILiteralNonVariableExtension>> premises = clause.getPremises();
        INamedLiteral namedConclusion = new NamedLiteral(conclusion, pelVariableContext);
        IConstructionPPrint conclusionConstructionPPrint
                = new LiteralConstructionPPrint(this.backRef, namedConclusion);
        List<IConstructionPPrint> premiseConstructionPPrintList
                = Collections.synchronizedList(premises
                        .parallelStream()
                        .map(premise -> new NamedLiteral(premise, pelVariableContext))
                        .map(npremise -> new LiteralConstructionPPrint(this.backRef, npremise))
                        .collect(Collectors.toList()));
        ListConstructionPPrint premisesConstructionPPrint
                = new ListConstructionPPrint(";", premiseConstructionPPrintList);
        premisesConstructionPPrint.pprintMultiLine(pprintBase);
        pprintBase.printToken(" ==> ");
        conclusionConstructionPPrint.pprintMultiLine(pprintBase);
    }

}
