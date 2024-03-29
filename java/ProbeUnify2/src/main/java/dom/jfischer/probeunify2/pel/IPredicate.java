/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.pel;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import java.util.List;

/**
 *
 * @author jfischer
 */
public interface IPredicate extends
        IExtension {

    List<IBaseExpression<ITrivialExtension>> getDomain();

}
