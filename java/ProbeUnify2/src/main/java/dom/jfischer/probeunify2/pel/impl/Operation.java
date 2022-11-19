/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.pel.IOperation;
import java.util.List;

/**
 *
 * @author jfischer
 */
public class Operation implements IOperation {

    private final IBaseExpression<ITrivialExtension> range;
    private final List<IBaseExpression<ITrivialExtension>> domain;

    public Operation(IBaseExpression<ITrivialExtension> range, List<IBaseExpression<ITrivialExtension>> domain) {
        this.range = range;
        this.domain = domain;
    }

    @Override
    public IBaseExpression<ITrivialExtension> getRange() {
        return this.range;
    }

    @Override
    public List<IBaseExpression<ITrivialExtension>> getDomain() {
        return this.domain;
    }

    @Override
    public void commit() {
        this.range.commit();
        this.domain
                .stream()
                .forEach(sortExpr -> sortExpr.commit());
    }

    @Override
    public void reset() {
        this.range.reset();
        this.domain
                .stream()
                .forEach(sortExpr -> sortExpr.reset());
    }

    @Override
    public String toString() {
        return "Operation{" + "range=" + range + ", domain=" + domain + '}';
    }

}
