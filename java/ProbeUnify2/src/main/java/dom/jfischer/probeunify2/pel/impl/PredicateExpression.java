/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.pel.IPredicate;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;

/**
 *
 * @author jfischer
 */
public class PredicateExpression implements IPredicateExpression {

    private final IPredicate extension;
    private final IBaseExpression<ITrivialExtension> baseExpression;

    public PredicateExpression(IPredicate extension, IBaseExpression<ITrivialExtension> baseExpression) {
        this.extension = extension;
        this.baseExpression = baseExpression;
    }

    @Override
    public void commit() {
        this.extension.commit();
        this.baseExpression.commit();
    }

    @Override
    public void reset() {
        this.extension.reset();
        this.baseExpression.reset();
    }

    @Override
    public IPredicate getExtension() {
        return this.extension;
    }

    @Override
    public IBaseExpression<ITrivialExtension> getBaseExpression() {
        return this.baseExpression;
    }

}
