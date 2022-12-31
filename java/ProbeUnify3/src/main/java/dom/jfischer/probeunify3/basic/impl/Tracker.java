/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.basic.impl;

import dom.jfischer.probeunify3.basic.ITracker;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 * @param <Type>
 */
public class Tracker<Type> implements ITracker<Type> {

    private final Map<Type, Type> map
            = new ConcurrentHashMap<>();

    @Override
    public Optional<Type> get(Type key) {
        Optional<Type> retval = Optional.empty();

        if (this.map.containsKey(key)) {
            retval = Optional.of(this.map.get(key));
        }

        return retval;
    }

    @Override
    public void put(Type key, Type value) {
        this.map.put(key, value);
    }

}
