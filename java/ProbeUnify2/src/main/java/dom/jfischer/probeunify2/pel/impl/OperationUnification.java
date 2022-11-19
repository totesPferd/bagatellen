/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IUnification;
import dom.jfischer.probeunify2.basic.impl.BaseUnification;
import dom.jfischer.probeunify2.basic.impl.MultiUnification;
import dom.jfischer.probeunify2.pel.IOperation;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class OperationUnification implements IUnification<IOperation> {

    private final IUnification<IBaseExpression<ITrivialExtension>> rangeUnification;
    private final IUnification<List<IBaseExpression<ITrivialExtension>>> domainUnification;

    public OperationUnification() {
        this.rangeUnification
                = new BaseUnification<>();
        this.domainUnification
                = new MultiUnification<>(this.rangeUnification);
    }

    @Override
    public boolean unify(IOperation arg1, IOperation arg2) {
        return this.domainUnification.unify(arg1.getDomain(), arg2.getDomain())
                && this.rangeUnification.unify(arg1.getRange(), arg2.getRange());
    }

}
