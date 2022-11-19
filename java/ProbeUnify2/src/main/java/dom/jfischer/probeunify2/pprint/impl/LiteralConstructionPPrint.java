/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pprint.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.INonVariable;
import dom.jfischer.probeunify2.module.INamedLiteral;
import dom.jfischer.probeunify2.module.impl.NamedTerm;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.pprint.IBackReference;
import dom.jfischer.probeunify2.pprint.IConstructionPPrint;
import dom.jfischer.probeunify2.pprint.IPPrintBase;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 *
 * @author jfischer
 */
public class LiteralConstructionPPrint implements IConstructionPPrint {

    private final IBackReference backRef;
    private final INamedLiteral literal;

    public LiteralConstructionPPrint(IBackReference backRef, INamedLiteral literal) {
        this.backRef = backRef;
        this.literal = literal;
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

        IBaseExpression<ILiteralNonVariableExtension> literalBaseExpression
                = this.literal.getLiteral();
        {
            Map<IBaseExpression<ILiteralNonVariableExtension>, String> literalRef = this.backRef.getLiteralRef();
            if (literalRef.containsKey(literalBaseExpression)) {
                retval = new StringConstructionPPrint(literalRef.get(literalBaseExpression));
            }
        }

        if (retval == null) {
            ITermVariableContext termVariableContext
                    = this.literal.getTermVariableContext();
            {
                Optional<INonVariable<ILiteralNonVariableExtension>> optLiteralNonVariable
                        = literalBaseExpression.nonVariable();
                if (optLiteralNonVariable.isPresent()) {
                    INonVariable<ILiteralNonVariableExtension> literalNonVariable
                            = optLiteralNonVariable.get();
                    ILiteralNonVariableExtension literalNonVariableExtension
                            = literalNonVariable.getNonVariableExtension();
                    IPredicateExpression predicate
                            = literalNonVariableExtension.getPredicate();
                    String predicateString = this.backRef.getPredicateRef().get(predicate);
                    List<IBaseExpression<ITermNonVariableExtension>> arguments
                            = literalNonVariableExtension.getArguments();
                    List<IConstructionPPrint> argumentConstructionPPrintList
                            = Collections.synchronizedList(arguments
                                    .parallelStream()
                                    .map(t -> new NamedTerm(t, termVariableContext))
                                    .map(nterm -> new TermConstructionPPrint(this.backRef, nterm))
                                    .collect(Collectors.toList()));
                    ListConstructionPPrint argumentsConstructionPPrint
                            = new ListConstructionPPrint(",", argumentConstructionPPrintList);
                    retval = new ApplicationConstructionPPrint(predicateString, argumentsConstructionPPrint);
                }
            }
        }

        return retval;
    }

}
