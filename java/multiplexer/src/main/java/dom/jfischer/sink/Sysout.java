package dom.jfischer.sink;

import dom.jfischer.RingBuffer;
import dom.jfischer.Sink;

/**
 * <p>
 * Sysout class.</p>
 *
 * @author jfischer
 * @version $Id: $Id
 */
public class Sysout extends Sink<String> {

    private final String name;

    /**
     * <p>
     * Constructor for Sysout.</p>
     *
     * @param ringBuffer a {@link dom.jfischer.RingBuffer} object.
     * @param name a {@link java.lang.String} object.
     */
    public Sysout(RingBuffer<String> ringBuffer, String name) {
        super(ringBuffer);
        this.name = name;
    }

    /**
     * <p>
     * run.</p>
     */
    public void run() {

        while (true) {
            String data = get();
            if (data != null) {
                String outData = "sysout " + this.name + ":" + data;
                System.out.println(outData);
            } else {
                break;
            }
        }

        System.out.println(
                "Sysout(" + this.name + ") thread has reached its end.");

    }

}
