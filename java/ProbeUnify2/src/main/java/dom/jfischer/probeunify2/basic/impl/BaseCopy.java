/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IBaseCopy;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public class BaseCopy<NonVariableExtension extends IExtension> implements
        IBaseCopy<NonVariableExtension, IBaseExpression<NonVariableExtension>> {

    @Override
    public IBaseExpression<NonVariableExtension> copy(ITracker<NonVariableExtension> tracker, IBaseExpression<NonVariableExtension> object) {
        return object.copy(tracker);
    }

    @Override
    public void collectLeafs(ILeafCollector<NonVariableExtension> leafCollector, IBaseExpression<NonVariableExtension> object) {
        object.collectLeafs(leafCollector);
    }

}
