/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.basic;

import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import java.util.Set;
import java.util.function.Function;

/**
 *
 * @author jfischer
 * @param <U>
 */
public interface ICompare<U> {

    CompareResult compare(
            IBaseExpression<ILiteralNonVariableExtension> arg1,
            IBaseExpression<ILiteralNonVariableExtension> arg2,
            IBaseExpression<ILiteralNonVariableExtension> cmp);

    Set<U> getMaximalSet(
            Function<U, IBaseExpression<ILiteralNonVariableExtension>> f,
            Set<U> candidates,
            IBaseExpression<ILiteralNonVariableExtension> cmp);

}
