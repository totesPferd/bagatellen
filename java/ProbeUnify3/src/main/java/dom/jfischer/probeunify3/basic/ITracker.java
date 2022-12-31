/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

import java.io.Serializable;
import java.util.Optional;

/**
 *
 * @author jfischer
 * @param <Type>
 */
public interface ITracker<Type> extends Serializable {

    Optional<Type> get(Type key);

    void put(Type key, Type value);

}
