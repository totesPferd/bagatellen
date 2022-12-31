/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

import java.io.Serializable;
import java.util.Optional;
import java.util.Set;

/**
 *
 * @author jfischer
 * @param <NonVariableXt>
 */
public interface ILeafCollector<NonVariableXt extends INonVariableXt> extends Serializable {
    
    Set<IVariable<NonVariableXt>> getLeafs();

    void undo();

    default boolean isLeaf() {
        Set<IVariable<NonVariableXt>> leafs = this.getLeafs();
        boolean retval = true;

        for (IVariable<NonVariableXt> leaf : leafs) {
            Optional<IVariable<NonVariableXt>> optVariable = leaf.dereference().variable();
            if (optVariable.isEmpty()) {
                retval = false;
                break;
            } else {
                IVariable<NonVariableXt> variable = optVariable.get();
                if (!leafs
                        .parallelStream()
                        .filter(v -> v != leaf)
                        .map(ov -> ov.dereference().variable())
                        .filter(ov -> ov.isPresent())
                        .map(ov -> ov.get())
                        .allMatch(v -> v != variable)) {
                    retval = false;
                    break;
                }
            }
        }

        return retval;
    }

    
}
