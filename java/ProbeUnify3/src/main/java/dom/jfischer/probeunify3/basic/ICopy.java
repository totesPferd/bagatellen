/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

import java.io.Serializable;

/**
 *
 * @author jfischer
 * @param <Type>
 * @param <Tracker>
 */
public interface ICopy<Type, Tracker> extends Serializable {
    
    Type copy(Tracker tracker, Type object);
    
}
