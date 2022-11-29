/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.impl.TrivialExtension;
import dom.jfischer.probeunify2.pel.INamedLiteral;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELVariableContext;

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

}
