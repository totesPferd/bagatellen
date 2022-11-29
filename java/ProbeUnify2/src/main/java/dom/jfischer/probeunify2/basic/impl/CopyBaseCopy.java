/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IBaseCopy;
import dom.jfischer.probeunify2.basic.ICopy;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ILeafCollector;
import dom.jfischer.probeunify2.basic.ITracker;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 * @param <Type>
 */
public class CopyBaseCopy<NonVariableExtension extends IExtension, Type> implements
        IBaseCopy<NonVariableExtension, Type> {

    private final ICopy<Type> copier;

    public CopyBaseCopy(ICopy<Type> copier) {
        this.copier = copier;
    }

    @Override
    public Type copy(ITracker<NonVariableExtension> tracker, Type object) {
        return this.copier.copy(tracker.getAllTrackers(), object);
    }

    @Override
    public void collectLeafs(ILeafCollector<NonVariableExtension> leafCollector, Type object) {
        this.copier.collectLeafs(leafCollector.getAllLeafCollectors(), object);
    }

}
