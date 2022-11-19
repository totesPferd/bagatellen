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
public interface ICheckVariableOccurence<NonVariableExtension extends IExtension> {

    /*
     * variable should be open, i.e. variable.value() == Optioanl.empty()
     */
    boolean containsVariable(NonVariableExtension object, IVariable<NonVariableExtension> variable);

}
