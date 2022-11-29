/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.basic;

import java.util.Optional;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public interface ISimpleTracker<NonVariableExtension extends IExtension> {

    Optional<IBaseExpression<NonVariableExtension>> get(IBaseExpression<NonVariableExtension> key);

    void put(IBaseExpression<NonVariableExtension> key, IBaseExpression<NonVariableExtension> value);

}
