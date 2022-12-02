/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2.module.impl;

import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.pprint.IBackReference;
import java.util.Map;
import java.util.Map.Entry;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.pel.IOperationExpression;
import dom.jfischer.probeunify2.pel.IPredicateExpression;
import dom.jfischer.probeunify2.proof.IClause;

/**
 *
 * @author jfischer
 */
public class ModuleHelper {

    public static void getBackReference(IModule in, IBackReference out, String prefix) {
        String realPrefix
                = prefix == null
                        ? ""
                        : prefix + ".";
        {
            Map<String, IModule> imports = in.getImports();
            for (Entry<String, IModule> entry : imports.entrySet()) {
                getBackReference(entry.getValue(), out, realPrefix + entry.getKey());
            }
        }
        {
            Map<String, INamedClause> axiomsIn = in.getAxioms();
            Map<IClause, String> axiomsOut = out.getAxiomRef();
            for (Entry<String, INamedClause> entry : axiomsIn.entrySet()) {
                axiomsOut.put(entry.getValue().getClause(), realPrefix + entry.getKey());
            }
        }
        {
            Map<String, IOperationExpression> operationsIn = in.getOperations();
            Map<IOperationExpression, String> operationsOut = out.getOperationRef();
            for (Entry<String, IOperationExpression> entry : operationsIn.entrySet()) {
                operationsOut.put(entry.getValue(), realPrefix + entry.getKey());
            }
        }
        {
            Map<String, IPredicateExpression> predicatesIn = in.getPredicates();
            Map<IPredicateExpression, String> predicatesOut = out.getPredicateRef();
            for (Entry<String, IPredicateExpression> entry : predicatesIn.entrySet()) {
                predicatesOut.put(entry.getValue(), realPrefix + entry.getKey());
            }
        }
        {
            Map<String, IBaseExpression<ITrivialExtension>> sortsIn = in.getSorts();
            Map<IBaseExpression<ITrivialExtension>, String> sortsOut = out.getSortRef();
            for (Entry<String, IBaseExpression<ITrivialExtension>> entry : sortsIn.entrySet()) {
                sortsOut.put(entry.getValue(), realPrefix + entry.getKey());
            }
        }
    }
}
