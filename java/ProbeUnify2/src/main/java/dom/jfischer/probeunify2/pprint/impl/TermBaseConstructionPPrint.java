/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.INonVariable;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pprint.IBackReference;
import dom.jfischer.probeunify2.pprint.IConstructionPPrint;
import dom.jfischer.probeunify2.pprint.IPPrintBase;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import dom.jfischer.probeunify2.basic.IVariableContext;

/**
 *
 * @author jfischer
 */
public class TermBaseConstructionPPrint implements IConstructionPPrint {

    private final IBackReference backRef;
    private final IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> termVariableContext;
    private final IBaseExpression<ITermNonVariableExtension> termBase;

    public TermBaseConstructionPPrint(
            IBackReference backRef,
            IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> termVariableContext,
            IBaseExpression<ITermNonVariableExtension> termBase) {
        this.backRef = backRef;
        this.termVariableContext = termVariableContext;
        this.termBase = termBase;
    }

    @Override
    public String getSingleLine() {
        return this.getConstructionPPrint().getSingleLine();
    }

    @Override
    public void pprintMultiLine(IPPrintBase pprintBase) {
        this.getConstructionPPrint().pprintMultiLine(pprintBase);
    }

    private IConstructionPPrint getConstructionPPrint() {
        IConstructionPPrint retval = null;
        IBaseExpression<ITermNonVariableExtension> actualTermBase
                = this.termBase.dereference();

        {
            Map<IBaseExpression<ITermNonVariableExtension>, String> termRef = this.backRef.getTermRef();
            if (termRef.containsKey(actualTermBase)) {
                retval = new StringConstructionPPrint(termRef.get(actualTermBase));
            }
        }

        if (retval == null) {
            {
                Optional<INonVariable<ITermNonVariableExtension>> optTermNonVariable
                        = actualTermBase.nonVariable();
                if (optTermNonVariable.isPresent()) {
                    INonVariable<ITermNonVariableExtension> termNonVariable
                            = optTermNonVariable.get();
                    ITermNonVariableExtension termNonVariableExtension
                            = termNonVariable.getNonVariableExtension();
                    IOperationExpression operation
                            = termNonVariableExtension.getOperation();
                    String operationString = this.backRef.getOperationRef().get(operation);
                    List<IBaseExpression<ITermNonVariableExtension>> arguments
                            = termNonVariableExtension.getArguments();
                    List<IConstructionPPrint> argumentConstructionPPrintList
                            = Collections.synchronizedList(arguments
                                    .parallelStream()
                                    .map(nterm -> new TermBaseConstructionPPrint(
                                    this.backRef,
                                    this.termVariableContext,
                                    nterm))
                                    .collect(Collectors.toList()));
                    ListConstructionPPrint argumentsConstructionPPrint
                            = new ListConstructionPPrint(",", argumentConstructionPPrintList);
                    retval = new ApplicationConstructionPPrint(operationString, argumentsConstructionPPrint);
                }
            }
            {
                Optional<IVariable<ITermNonVariableExtension>> optTermVariable
                        = actualTermBase.variable();
                if (optTermVariable.isPresent()) {
                    IVariable<ITermNonVariableExtension> termVariable
                            = optTermVariable.get();
                    retval = new VariableConstructionPPrint<>("?", termVariableContext, termVariable);
                }
            }
        }

        return retval;
    }

}
