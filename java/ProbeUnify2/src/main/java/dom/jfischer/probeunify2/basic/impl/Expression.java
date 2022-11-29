/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.IExtension;

/**
 *
 * @author jfischer
 */
public class Expression<Extension extends IExtension, NonVariableExtension extends IExtension> implements
        IExpression<Extension, NonVariableExtension> {

    Extension extension;
    IBaseExpression<NonVariableExtension> baseExpression;

    public Expression(Extension extension, IBaseExpression<NonVariableExtension> baseExpression) {
        this.extension = extension;
        this.baseExpression = baseExpression;
    }

    @Override
    public Extension getExtension() {
        return this.extension;
    }

    @Override
    public IBaseExpression<NonVariableExtension> getBaseExpression() {
        return this.baseExpression;
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

}
