/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Exception.java to edit this template
 */
package dom.jfischer.probeunify3.exceptions;

/**
 *
 * @author jfischer
 */
public class LengthDoesNotMatchException extends RuntimeException {

    /**
     * Creates a new instance of <code>LengthDoesNotMatchException</code>
     * without detail message.
     */
    public LengthDoesNotMatchException() {
        super("length does not match");
    }

    /**
     * Constructs an instance of <code>LengthDoesNotMatchException</code> with
     * the specified detail message.
     *
     * @param msg the detail message.
     */
    public LengthDoesNotMatchException(String msg) {
        super("length does not match: " + msg);
    }
}
