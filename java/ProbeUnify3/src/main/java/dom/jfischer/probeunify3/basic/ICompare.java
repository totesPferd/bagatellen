/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

import java.io.Serializable;
import java.util.Set;
import java.util.function.Function;

/**
 *
 * @author jfischer
 * @param <U>
 */
public interface ICompare<U> extends Serializable {

    CompareResult compare(
            IXpr<ITNonVariableXt> arg1,
            IXpr<ITNonVariableXt> arg2,
            IXpr<ITNonVariableXt> cmp);

    Set<U> getMaximalSet(
            Function<U, IXpr<ITNonVariableXt>> f,
            Set<U> candidates,
            IXpr<ITNonVariableXt> cmp);

}
