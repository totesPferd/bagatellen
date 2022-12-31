/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names;

import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.IXpr;
import java.io.Serializable;
import java.util.List;

/**
 *
 * @author jfischer
 */
public interface IOperationSignature extends Serializable {

    List<IXpr<INonVariableXt>> getDomain();

    IXpr<INonVariableXt> getRange();

}
