/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.pph.impl;

import dom.jfischer.pph.IConstructionPPrint;
import dom.jfischer.pph.IPPrintBase;
import dom.jfischer.pph.impl.ApplicationConstructionPPrint;
import dom.jfischer.pph.impl.EnumerationConstructionPPrint;
import dom.jfischer.probeunify3.basic.INonVariable;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunifyfrontend1.names.IVariableNameInfo;
import dom.jfischer.probeunifyfrontend1.pph.IBackReference;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class XprConstructionPPrint implements IConstructionPPrint {

    private final IVariableNameInfo variableNameInfo;
    private final IBackReference backReference;
    private final IXpr<ITNonVariableXt> xpr;

    public XprConstructionPPrint(IVariableNameInfo variableNameInfo, IBackReference backReference, IXpr<ITNonVariableXt> xpr) {
        this.variableNameInfo = variableNameInfo;
        this.backReference = backReference;
        this.xpr = xpr;
    }

    @Override
    public String getSingleLine() {
        return this.getConstructionPPrint().getSingleLine();
    }

    @Override
    public void pprintMultiLine(IPPrintBase ippb) {
        this.getConstructionPPrint().pprint(ippb);
    }

    private IConstructionPPrint getConstructionPPrint() {
        IXpr<ITNonVariableXt> dereferencedXpr = this.xpr.dereference();
        IConstructionPPrint retval = null;
        {
            Optional<INonVariable<ITNonVariableXt>> optNonVariableXpr
                    = dereferencedXpr.nonVariable();
            if (optNonVariableXpr.isPresent()) {
                INonVariable<ITNonVariableXt> nonVariableXpr
                        = optNonVariableXpr.get();

                ITNonVariableXt nonVariableXt
                        = nonVariableXpr.getNonVariableXt();
                IXpr<INonVariableXt> symbol
                        = nonVariableXt.getSymbol().dereference();
                String symbolName
                        = this.backReference.getSymbolRef().get(symbol);
                List<IXpr<ITNonVariableXt>> arguments
                        = nonVariableXt.getArguments();
                List<IConstructionPPrint> argumentConstructionPPrints = arguments
                        .parallelStream()
                        .map(arg -> new XprConstructionPPrint(
                                this.variableNameInfo,
                                this.backReference,
                                arg
                        ))
                        .collect(Collectors.toList());
                IConstructionPPrint argumentsConstructionPPrint
                        =  new EnumerationConstructionPPrint(",", argumentConstructionPPrints);
                retval
                        =  new ApplicationConstructionPPrint(
                                symbolName,
                                argumentsConstructionPPrint);
            }
        }
        {
            Optional<IVariable<ITNonVariableXt>> optVariableXpr
                    = dereferencedXpr.variable();
            if (optVariableXpr.isPresent()) {
                IVariable<ITNonVariableXt> variableXpr
                        = optVariableXpr.get();
                
                retval
                        =  new VariableConstructionPPrint(
                                this.variableNameInfo,
                                variableXpr
                        );
            }
        }
        return retval;
    }

}
