/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.basic;

import java.io.Serializable;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 * @param <Type>
 */
public interface IBaseCopy<NonVariableExtension extends IExtension, Type> extends
        Serializable {

    Type copy(ITracker<NonVariableExtension> tracker, Type object);

    void collectLeafs(ILeafCollector<NonVariableExtension> leafCollector, Type object);
}
