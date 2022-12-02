/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.INonVariable;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.basic.impl.TrivialExtension;
import dom.jfischer.probeunify2.pel.INamedLiteral;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author jfischer
 */
public class NamedLiteral implements INamedLiteral {

    private final IBaseExpression<ILiteralNonVariableExtension> literal;
    private final IPELVariableContext pelVariableContext;

    public NamedLiteral(IBaseExpression<ILiteralNonVariableExtension> literal, IPELVariableContext pelVariableContext) {
        this.literal = literal;
        this.pelVariableContext = pelVariableContext;
    }

    @Override
    public IBaseExpression<ILiteralNonVariableExtension> getLiteral() {
        return this.literal;
    }

    @Override
    public void commit() {
        this.literal.commit();
        this.pelVariableContext.commit();
    }

    @Override
    public void reset() {
        this.literal.reset();
        this.pelVariableContext.reset();
    }

    @Override
    public ITrivialExtension getExtension() {
        return new TrivialExtension();
    }

    @Override
    public IBaseExpression<ILiteralNonVariableExtension> getBaseExpression() {
        return this.literal;
    }

    @Override
    public IPELVariableContext getPelVariableContext() {
        return this.pelVariableContext;
    }

    @Override
    public boolean isFree() {
        boolean retval = true;
        IBaseExpression<ILiteralNonVariableExtension> actualLiteral
                = this.literal.dereference();
        {
            Optional<INonVariable<ILiteralNonVariableExtension>> optNonVariableLiteral
                    = actualLiteral.nonVariable();
            if (optNonVariableLiteral.isPresent()) {
                INonVariable<ILiteralNonVariableExtension> nonVariableLiteral
                        = optNonVariableLiteral.get();
                List<IBaseExpression<ITermNonVariableExtension>> arguments
                        = nonVariableLiteral.getNonVariableExtension().getArguments();
                retval = arguments
                        .parallelStream()
                        .map(t -> new NamedTerm(t, this.pelVariableContext.getTermVariableContext()))
                        .allMatch(namedTerm -> namedTerm.isFree());
            }
        }
        {
            Optional<IVariable<ILiteralNonVariableExtension>> optVariableLiteral
                    = actualLiteral.variable();
            if (optVariableLiteral.isPresent()) {
                IVariable<ILiteralNonVariableExtension> variableLiteral
                        = optVariableLiteral.get();
                retval = this.pelVariableContext.getLiteralVariableContext().isFree(variableLiteral);
            }
        }
        return retval;
    }

}
