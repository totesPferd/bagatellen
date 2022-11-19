/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2.antlr;

import dom.jfischer.probeunify2.module.INamedClause;
import dom.jfischer.probeunify2.module.INamedLiteral;
import dom.jfischer.probeunify2.module.INamedTerm;
import dom.jfischer.probeunify2.proof.IClause;
import java.util.Set;

/**
 *
 * @author jfischer
 */
public interface IPelThisListener {

    String getModuleName();

    Set<IClause> getProof();
    
    void resetProof();

    void resetTermVariableContext();

    INamedTerm popTerm();

    INamedLiteral popLiteral();

    INamedClause popClause();

}
