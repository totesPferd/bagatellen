/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.module;

import dom.jfischer.probeunify2.antlr.impl.CtxBean;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.IExtension;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.exception.QualificatorException;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 *
 * @author jfischer
 */
public interface IModule extends IExtension {

    CtxBean getInitialCtxBean();

    Map<String, INamedClause> getAxioms();

    Map<String, IModule> getImports();

    Map<String, IOperationExpression> getOperations();

    Map<String, IPredicateExpression> getPredicates();

    Map<String, IBaseExpression<ITrivialExtension>> getSorts();

    Optional<IModule> derefModule(List<String> qualificator) throws QualificatorException;

    ITrivialExtension getTrivialExtension();

}
