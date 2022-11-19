/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.module.INamedLiteral;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;

/**
 *
 * @author jfischer
 */
public class NamedLiteral implements INamedLiteral {

    private final IBaseExpression<ILiteralNonVariableExtension> literal;
    private final ITermVariableContext termVariableContext;

    public NamedLiteral(IBaseExpression<ILiteralNonVariableExtension> literal, ITermVariableContext termVariableContext) {
        this.literal = literal;
        this.termVariableContext = termVariableContext;
    }

    @Override
    public IBaseExpression<ILiteralNonVariableExtension> getLiteral() {
        return this.literal;
    }

    @Override
    public ITermVariableContext getTermVariableContext() {
        return this.termVariableContext;
    }

    @Override
    public void commit() {
        this.literal.commit();
        this.termVariableContext.commit();
    }

    @Override
    public void reset() {
        this.literal.reset();
        this.termVariableContext.reset();
    }

}
