/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.pel.IOperation;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;

/**
 *
 * @author jfischer
 */
public class OperationExpression implements IOperationExpression {

    private final IOperation extension;
    private final IBaseExpression<ITrivialExtension> baseExpression;

    public OperationExpression(IOperation extension, IBaseExpression<ITrivialExtension> baseExpression) {
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
    public IOperation getExtension() {
        return this.extension;
    }

    @Override
    public IBaseExpression<ITrivialExtension> getBaseExpression() {
        return this.baseExpression;
    }

    @Override
    public String toString() {
        return "OperationExpression{" + "extension=" + extension + '}';
    }

}
