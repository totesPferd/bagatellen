/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Exception.java to edit this template
 */
package dom.jfischer.probeunify2.exception;

/**
 *
 * @author jfischer
 */
public class SortsDoesNotMatchException extends RuntimeException {

    /**
     * Creates a new instance of <code>SortsDoesNotMatchException</code> without
     * detail message.
     */
    public SortsDoesNotMatchException() {
        super("sorts does not match");
    }

    /**
     * Constructs an instance of <code>SortsDoesNotMatchException</code> with
     * the specified detail message.
     *
     * @param msg the detail message.
     */
    public SortsDoesNotMatchException(String msg) {
        super("sorts does not match: " + msg);
    }
}
