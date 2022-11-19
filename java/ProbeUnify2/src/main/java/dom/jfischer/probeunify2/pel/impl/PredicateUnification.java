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
import dom.jfischer.probeunify2.pel.IPredicate;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class PredicateUnification implements IUnification<IPredicate> {

    private final IUnification<List<IBaseExpression<ITrivialExtension>>> domainUnification;

    public PredicateUnification() {
        IUnification<IBaseExpression<ITrivialExtension>> sortUnification
                =  new BaseUnification<>();
        this.domainUnification 
                =  new MultiUnification<>(sortUnification);
    }
    
    
    
    @Override
    public boolean unify(IPredicate arg1, IPredicate arg2) {
        return this.domainUnification.unify(arg1.getDomain(), arg2.getDomain());
    }
    
}
