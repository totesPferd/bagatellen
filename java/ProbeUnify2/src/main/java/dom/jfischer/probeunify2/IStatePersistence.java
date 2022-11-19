/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dom.jfischer.probeunify2;

import java.io.Serializable;

/**
 *
 * @author jfischer
 */
public interface IStatePersistence extends Serializable {
    
    IState restore();
    
    boolean backup(IState state);
    
}
