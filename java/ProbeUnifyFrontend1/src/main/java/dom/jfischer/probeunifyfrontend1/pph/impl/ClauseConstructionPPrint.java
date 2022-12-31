/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.pph.impl;

import dom.jfischer.pph.IConstructionPPrint;
import dom.jfischer.pph.IPPrintBase;
import dom.jfischer.pph.impl.ListConstructionPPrint;
import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunifyfrontend1.names.IVariableNameInfo;
import dom.jfischer.probeunifyfrontend1.pph.IBackReference;
import java.util.HashSet;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class ClauseConstructionPPrint implements IConstructionPPrint {

    private final IVariableNameInfo variableNameInfo;
    private final IBackReference backReference;
    private final IClause clause;

    public ClauseConstructionPPrint(IVariableNameInfo variableNameInfo, IBackReference backReference, IClause clause) {
        this.variableNameInfo = variableNameInfo;
        this.backReference = backReference;
        this.clause = clause;
    }

    @Override
    public String getSingleLine() {
        IVariableContext<ITNonVariableXt> variableContext
                = this.clause.getVariableContext();
        IConstructionPPrint variableContextConstructionPPrint
                = new VariableContextConstructionPPrint(
                        this.variableNameInfo,
                        variableContext
                );
        List<IClause> premises
                = this.clause.getPremises();
        List<IConstructionPPrint> premiseConstructionPPrints
                = premises
                        .parallelStream()
                        .map(premis -> new ClauseConstructionPPrint(
                        this.variableNameInfo,
                        this.backReference,
                        premis
                ))
                        .collect(Collectors.toList());
        IConstructionPPrint premisesConstructionPPrint
                = new ListConstructionPPrint(premiseConstructionPPrints);
        IXpr<ITNonVariableXt> conclusion
                = this.clause.getConclusion();
        IConstructionPPrint conclusionConstructionPPrint
                = new XprConstructionPPrint(
                        this.variableNameInfo,
                        this.backReference,
                        conclusion
                );
        return
                variableContextConstructionPPrint.getSingleLine() + " "
                + premisesConstructionPPrint.getSingleLine() + " ==> "
                + conclusionConstructionPPrint.getSingleLine();
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        IVariableContext<ITNonVariableXt> variableContext
                = this.clause.getVariableContext();
        IConstructionPPrint variableContextConstructionPPrint
                = new VariableContextConstructionPPrint(
                        this.variableNameInfo,
                        variableContext
                );
        List<IClause> premises
                = this.clause.getPremises();
        List<IConstructionPPrint> premiseConstructionPPrints
                = premises
                        .parallelStream()
                        .map(premis -> new ClauseConstructionPPrint(
                        this.variableNameInfo,
                        this.backReference,
                        premis
                ))
                        .collect(Collectors.toList());
        IConstructionPPrint premisesConstructionPPrint
                = new ListConstructionPPrint(premiseConstructionPPrints);
        IXpr<ITNonVariableXt> conclusion
                = this.clause.getConclusion();
        IConstructionPPrint conclusionConstructionPPrint
                = new XprConstructionPPrint(
                        this.variableNameInfo,
                        this.backReference,
                        conclusion
                );
        
        variableContextConstructionPPrint.pprint(pprintBase);
        pprintBase.setDeeperIndent();
        premisesConstructionPPrint.pprint(pprintBase);
        pprintBase.restoreIndent();
        pprintBase.printNewLine();
        pprintBase.printToken("==>");
        pprintBase.setDeeperIndent();
        conclusionConstructionPPrint.pprint(pprintBase);
        pprintBase.restoreIndent();
    }

}
