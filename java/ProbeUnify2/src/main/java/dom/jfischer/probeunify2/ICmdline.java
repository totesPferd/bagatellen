/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2;

import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.pel.INamedClause;

/**
 *
 * @author jfischer
 */
public interface ICmdline {

    IModule getModule();

    void setConjecture(INamedClause conjecture);

    void setModuleName(String moduleName);

    void setState(IState state);

    IState getState();

}
