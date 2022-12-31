/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

import java.util.Optional;

/**
 *
 * @author jfischer
 * @param <NonVariableXt>
 */
public interface IXpr<NonVariableXt extends INonVariableXt> extends
        INonVariableXt {

    IXpr<NonVariableXt> dereference();

    Optional<IVariable<NonVariableXt>> variable();

    Optional<INonVariable<NonVariableXt>> nonVariable();

    boolean containsVariable(IVariable<NonVariableXt> variable);

    boolean equateNonVariable(INonVariable<NonVariableXt> nonVariable);

    void collectLeafs(ILeafCollector<NonVariableXt> leafCollector);
    
    boolean isLeaf();
    
    default boolean eq(IXpr<NonVariableXt> other) {
        return this.dereference() == other.dereference();
    }
    
}
