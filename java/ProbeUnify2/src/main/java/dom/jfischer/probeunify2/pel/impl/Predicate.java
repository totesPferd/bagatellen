/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.pel.IPredicate;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class Predicate implements IPredicate {

    private final List<IBaseExpression<ITrivialExtension>> domain;

    public Predicate(List<IBaseExpression<ITrivialExtension>> domain) {
        this.domain = domain;
    }

    @Override
    public List<IBaseExpression<ITrivialExtension>> getDomain() {
        return this.domain;
    }

    @Override
    public void commit() {
        this.domain
                .stream()
                .forEach(sortExpr -> sortExpr.commit());
    }

    @Override
    public void reset() {
        this.domain
                .stream()
                .forEach(sortExpr -> sortExpr.reset());
    }

}
