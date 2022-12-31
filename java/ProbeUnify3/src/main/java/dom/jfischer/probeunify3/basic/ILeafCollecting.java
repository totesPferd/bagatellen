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
 * @param <NonVariableXt>
 */
public interface ILeafCollecting<Type, NonVariableXt extends INonVariableXt> extends Serializable {
    
    void collectLeafs(ILeafCollector<NonVariableXt> leafCollector, Type object);
    
}
