/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dom.jfischer.probeunify2;

import org.jline.terminal.Terminal;
import org.jline.terminal.Terminal.SignalHandler;

/**
 *
 * @author jfischer
 */
public class SigHandler implements SignalHandler {

    private final IState state;
    private final IStatePersistence statePersistence =  new StatePersistence();

    public SigHandler(IState state) {
        this.state = state;
    }
    
    @Override
    public void handle(Terminal.Signal signal) {
        this.statePersistence.backup(this.state);
    }
    
}
