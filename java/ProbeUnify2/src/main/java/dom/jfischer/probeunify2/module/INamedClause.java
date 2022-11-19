/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.module;

import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.pprint.ITermVariableContext;
import dom.jfischer.probeunify2.proof.IClause;

/**
 *
 * @author jfischer
 */
public interface INamedClause extends IExtension {

    IClause getClause();

    ITermVariableContext getTermVariableContext();

}
