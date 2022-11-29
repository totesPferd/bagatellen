/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.pel.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.pel.ITermExtension;

/**
 *
 * @author jfischer
 */
public class TermExtension implements ITermExtension {

    private final IBaseExpression<ITrivialExtension> sort;

    public TermExtension(IBaseExpression<ITrivialExtension> sort) {
        this.sort = sort;
    }

    @Override
    public IBaseExpression<ITrivialExtension> getSort() {
        return this.sort;
    }

    @Override
    public void commit() {
    }

    @Override
    public void reset() {
    }

}
