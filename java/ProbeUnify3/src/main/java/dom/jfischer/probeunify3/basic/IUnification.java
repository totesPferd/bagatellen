/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

import java.io.Serializable;

/**
 *
 * @author jfischer
 * @param <Type>
 */
public interface IUnification<Type> extends Serializable {

    boolean unify(Type arg1, Type arg2);

}
