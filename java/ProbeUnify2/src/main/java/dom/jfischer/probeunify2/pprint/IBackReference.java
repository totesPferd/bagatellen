/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.pprint;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import java.util.Map;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import dom.jfischer.probeunify2.proof.IClause;
import java.io.Serializable;

/**
 *
 * @author jfischer
 */
public interface IBackReference extends Serializable {

    Map<IModule, String> getModuleRef();

    Map<IClause, String> getAxiomRef();
    
    Map<IOperationExpression, String> getOperationRef();

    Map<IPredicateExpression, String> getPredicateRef();

    Map<IBaseExpression<ITrivialExtension>, String> getSortRef();

}
