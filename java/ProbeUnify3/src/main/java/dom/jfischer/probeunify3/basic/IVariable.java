/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

/**
 *
 * @author jfischer
 * @param <NonVariableXt>
 */
public interface IVariable<NonVariableXt extends INonVariableXt> extends
        IXpr<NonVariableXt> {

    void clear();

    void setValue(IXpr<NonVariableXt> value);

}
