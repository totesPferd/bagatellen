/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.pph.impl;

import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunify3.module.IModule;
import dom.jfischer.probeunify3.module.IObject;
import dom.jfischer.probeunifyfrontend1.names.IPELXt;
import dom.jfischer.probeunifyfrontend1.pph.IBackReference;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 */
public class BackReference implements IBackReference {

    private final Map<IModule<IPELXt>, String> moduleRef
            = new ConcurrentHashMap<>();
    private final Map<IClause, String> axiomRef
            = new ConcurrentHashMap<>();
    private final Map<IXpr<INonVariableXt>, String> symbolRef
            = new ConcurrentHashMap<>();
    private final Map<IXpr<INonVariableXt>, String> sortRef
            = new ConcurrentHashMap<>();

    @Override
    public Map<IModule<IPELXt>, String> getModuleRef() {
        return this.moduleRef;
    }

    @Override
    public Map<IClause, String> getAxiomRef() {
        return this.axiomRef;
    }

    @Override
    public Map<IXpr<INonVariableXt>, String> getSymbolRef() {
        return this.symbolRef;
    }

    @Override
    public Map<IXpr<INonVariableXt>, String> getSortRef() {
        return this.sortRef;
    }

    @Override
    public void put(IModule<IPELXt> module) {
        put(module, "");
    }

    private void putWithPrefix(IModule<IPELXt> module, String prefix) {
        this.put(module, prefix + ".");
    }

    private void put(IModule<IPELXt> module, String prefix) {
        {
            Map<String, IObject> quals = module.getXt().getQuals();
            Map<IObject, IModule<IPELXt>> importsDict = module.getImports();
            for (Entry<String, IObject> entry : quals.entrySet()) {
                String keyString = entry.getKey();
                IModule<IPELXt> subModule = importsDict.get(entry.getValue());
                String nextPrefix = prefix + keyString;
                this.moduleRef.put(subModule, nextPrefix);
                this.putWithPrefix(subModule, nextPrefix);
            }
        }
        {
            Map<String, IObject> axiomsIn = module.getXt().getAxioms();
            Map<IObject, IClause> axiomsDict = module.getAxioms();
            for (Entry<String, IObject> entry : axiomsIn.entrySet()) {
                String keyString = entry.getKey();
                String nextPrefix = prefix + keyString;
                this.axiomRef.put(axiomsDict.get(entry.getValue()), nextPrefix);
            }
        }
        {
            Map<String, IObject> operationsIn = module.getXt().getOperations();
            Map<IObject, IXpr<INonVariableXt>> operationsDict = module.getCs();
            for (Entry<String, IObject> entry : operationsIn.entrySet()) {
                String keyString = entry.getKey();
                String nextPrefix = prefix + keyString;
                this.symbolRef.put(operationsDict.get(entry.getValue()).dereference(), nextPrefix);
            }
        }
        {
            Map<String, IObject> predicatesIn = module.getXt().getPredicates();
            Map<IObject, IXpr<INonVariableXt>> predicatesDict = module.getCs();
            for (Entry<String, IObject> entry : predicatesIn.entrySet()) {
                String keyString = entry.getKey();
                String nextPrefix = prefix + keyString;
                this.symbolRef.put(predicatesDict.get(entry.getValue()).dereference(), nextPrefix);
            }
        }
        {
            Map<String, IObject> sortsIn = module.getXt().getSorts();
            Map<IObject, IXpr<INonVariableXt>> sortsDict = module.getCs();
            for (Entry<String, IObject> entry : sortsIn.entrySet()) {
                String keyString = entry.getKey();
                String nextPrefix = prefix + keyString;
                this.sortRef.put(sortsDict.get(entry.getValue()).dereference(), nextPrefix);
            }
        }
    }

}
