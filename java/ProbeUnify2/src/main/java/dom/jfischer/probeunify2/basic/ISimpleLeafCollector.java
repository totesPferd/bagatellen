/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.basic;

import java.io.Serializable;
import java.util.Optional;
import java.util.Set;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public interface ISimpleLeafCollector<NonVariableExtension extends IExtension>
        extends Serializable {

    Set<IVariable<NonVariableExtension>> getLeafs();

    void undo();

    default boolean isLeaf() {
        Set<IVariable<NonVariableExtension>> leafs = this.getLeafs();
        boolean retval = true;

        for (IVariable<NonVariableExtension> leaf : leafs) {
            Optional<IVariable<NonVariableExtension>> optVariable = leaf.dereference().variable();
            if (optVariable.isEmpty()) {
                retval = false;
                break;
            } else {
                IVariable<NonVariableExtension> variable = optVariable.get();
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
