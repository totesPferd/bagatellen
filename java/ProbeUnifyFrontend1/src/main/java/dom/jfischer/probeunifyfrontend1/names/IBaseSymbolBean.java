/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunifyfrontend1.names;

import java.io.Serializable;

/**
 *
 * @author jfischer
 */
public interface IBaseSymbolBean extends Serializable {

    String getSymbol();

    void setSymbol(String symbol);
    
    boolean parseName(String name);

}
