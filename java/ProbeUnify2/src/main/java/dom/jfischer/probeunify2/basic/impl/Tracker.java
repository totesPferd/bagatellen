/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.basic.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ITracker;
import dom.jfischer.probeunify2.pel.IPELTracker;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public class Tracker<
        NonVariableExtension extends IExtension> implements
        ITracker<NonVariableExtension> {

    private final IPELTracker allTrackers;
    private final Map<IBaseExpression<NonVariableExtension>, IBaseExpression<NonVariableExtension>> map
            = new ConcurrentHashMap<>();

    public Tracker(IPELTracker allTrackers) {
        this.allTrackers = allTrackers;
    }

    @Override
    public Optional<IBaseExpression<NonVariableExtension>> get(IBaseExpression<NonVariableExtension> key) {
        return Optional.ofNullable(this.map.get(key));
    }

    @Override
    public void put(IBaseExpression<NonVariableExtension> key, IBaseExpression<NonVariableExtension> value) {
        this.map.put(key, value);
    }

    @Override
    public IPELTracker getAllTrackers() {
        return this.allTrackers;
    }

}
