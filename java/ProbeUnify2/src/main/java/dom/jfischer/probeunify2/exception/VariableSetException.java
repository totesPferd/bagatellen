/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Exception.java to edit this template
 */
package dom.jfischer.probeunify2.exception;

/**
 *
 * @author jfischer
 */
public class VariableSetException extends RuntimeException {

    /**
     * Creates a new instance of <code>VariableSetException</code> without
     * detail message.
     */
    public VariableSetException() {
        super("Variable already set before");
    }

    /**
     * Constructs an instance of <code>VariableSetException</code> with the
     * specified detail message.
     *
     * @param msg the detail message.
     */
    public VariableSetException(String msg) {
        super("Variable already set before: " + msg);
    }
}
