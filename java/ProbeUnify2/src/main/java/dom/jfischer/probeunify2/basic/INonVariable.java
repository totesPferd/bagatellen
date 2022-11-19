/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.basic;

/**
 *
 * @author jfischer
 * @param <NonVariableExtension>
 */
public interface INonVariable<
        NonVariableExtension extends IExtension> extends
        IBaseExpression<NonVariableExtension> {

    NonVariableExtension getNonVariableExtension();

}
