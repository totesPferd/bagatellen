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
public interface IBaseExpression<
        NonVariableExtension extends IExtension> extends
        IExtension {

    Optional<IVariable<NonVariableExtension>> variable();

    Optional<INonVariable<NonVariableExtension>> nonVariable();

    IBaseExpression<NonVariableExtension> dereference();

    /*
     * variable should be open, i.e. variable.value() == Optioanl.empty()
     */
    boolean containsVariable(IVariable<NonVariableExtension> variable);
    
    boolean equateNonVariable(INonVariable<NonVariableExtension> other);

    IBaseExpression<NonVariableExtension> copy(ITracker<NonVariableExtension> tracker);

    void collectLeafs(ILeafCollector<NonVariableExtension> leafCollector);

    default boolean eq(IBaseExpression<NonVariableExtension> other) {
        return this.dereference() == other.dereference();
    }
    
}
