/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify3.module.impl;

import dom.jfischer.probeunify3.basic.IClause;
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunify3.module.IModule;
import dom.jfischer.probeunify3.module.IModuleXt;
import dom.jfischer.probeunify3.module.IObject;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author jfischer
 * @param <Xt>
 */
public class Module<Xt extends IModuleXt> implements IModule<Xt> {

    private final Map<IObject, IClause> axioms
            = new ConcurrentHashMap<>();
    private final Map<IObject, IModule<Xt>> imports
            = new ConcurrentHashMap<>();
    private final Map<IObject, IXpr<INonVariableXt>> cs
            = new ConcurrentHashMap<>();
    
    private final Xt xt;

    public Module(Xt xt) {
        this.xt = xt;
    }

    @Override
    public Xt getXt() {
        return this.xt;
    }

    @Override
    public Map<IObject, IClause> getAxioms() {
        return this.axioms;
    }

    @Override
    public Map<IObject, IModule<Xt>> getImports() {
        return this.imports;
    }

    @Override
    public Map<IObject, IXpr<INonVariableXt>> getCs() {
        return this.cs;
    }

    @Override
    public void commit() {
        this.xt.commit();
        this.imports.entrySet()
                .parallelStream()
                .forEach(imp -> imp.getValue().commit());
        this.cs.entrySet()
                .parallelStream()
                .forEach(c -> c.getValue().commit());
    }

    @Override
    public void reset() {
        this.xt.reset();
        this.imports.entrySet()
                .parallelStream()
                .forEach(imp -> imp.getValue().reset());
        this.cs.entrySet()
                .parallelStream()
                .forEach(c -> c.getValue().reset());
    }

}
