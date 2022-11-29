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
public interface IVariable<
        NonVariableExtension extends IExtension> extends
        IBaseExpression<NonVariableExtension> {

    void clear();

    Optional<IBaseExpression<NonVariableExtension>> value();

    /*
     * this.value() should be Optional.empty();
     * value should be value.isDereferenced();
     */
    void setValue(IBaseExpression<NonVariableExtension> value);

}
