/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names;

import com.google.common.collect.BiMap;
import dom.jfischer.probeunify3.module.IModuleXt;
import dom.jfischer.probeunify3.module.IObject;
import java.util.Map;

/**
 *
 * @author jfischer
 */
public interface IPELXt extends IModuleXt {

    BiMap<String, IObject> getSorts();

    BiMap<String, IObject> getOperations();

    BiMap<String, IObject> getPredicates();

    BiMap<String, IObject> getAxioms();

    BiMap<String, IObject> getQuals();

    Map<IObject, IOperationSignature> getOperationSignatures();

    Map<IObject, IPredicateSignature> getPredicateSignatures();

}
