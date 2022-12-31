/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

import java.util.List;

/**
 *
 * @author jfischer
 */
public interface IClause extends IResettable {
    
    IVariableContext<ITNonVariableXt> getVariableContext();
    
    IXpr<ITNonVariableXt> getConclusion();
    
    List<IClause> getPremises();
    
}
