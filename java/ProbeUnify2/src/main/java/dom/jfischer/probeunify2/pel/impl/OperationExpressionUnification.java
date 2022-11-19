/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IExpression;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.impl.Unification;
import dom.jfischer.probeunify2.pel.IOperation;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;

/**
 *
 * @author jfischer
 */
public class OperationExpressionUnification implements IUnification<IOperationExpression> {

    private final IUnification<IExpression<IOperation, ITrivialExtension>> baseUnification;

    public OperationExpressionUnification() {
        IUnification<IOperation> extensionUnification = new OperationUnification();
        this.baseUnification = new Unification<>(extensionUnification);
    }

    @Override
    public boolean unify(IOperationExpression arg1, IOperationExpression arg2) {
        return this.baseUnification.unify(arg1, arg2);
    }

}
