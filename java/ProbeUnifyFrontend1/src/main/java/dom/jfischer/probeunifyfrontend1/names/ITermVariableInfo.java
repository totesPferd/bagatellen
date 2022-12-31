/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names;

import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariable;
import dom.jfischer.probeunify3.basic.IXpr;
import java.io.Serializable;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author jfischer
 */
public interface ITermVariableInfo extends Serializable {

    Map<IVariable<ITNonVariableXt>, IXpr<INonVariableXt>> getSorts();

    void retainAll(Set<IVariable<ITNonVariableXt>> variables);
}
