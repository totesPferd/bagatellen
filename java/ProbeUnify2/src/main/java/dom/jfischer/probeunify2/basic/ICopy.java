/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.basic;

import dom.jfischer.probeunify2.pel.IPELLeafCollector;
import dom.jfischer.probeunify2.pel.IPELTracker;
import java.io.Serializable;

/**
 *
 * @author jfischer
 * @param <Type>
 */
public interface ICopy<Type> extends Serializable {

    Type copy(IPELTracker tracker, Type object);

    void collectLeafs(IPELLeafCollector leafCollector, Type object);

}
