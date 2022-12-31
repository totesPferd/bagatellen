/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify3.basic;

import java.util.List;
import java.util.Optional;

/**
 *
 * @author jfischer
 */
public interface IAssumptionsContext extends IResettable {

    Optional<IAssumptionsContext> getParent();

    List<IClause> getAssumptions();

}
