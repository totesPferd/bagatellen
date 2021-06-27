package dom.jfischer.source;

import dom.jfischer.RingBuffer;
import dom.jfischer.Source;

/**
 * <p>
 * Counter class.</p>
 *
 * @author jfischer
 * @version $Id: $Id
 */
public class Counter extends Source<String> {

    private final String name;

    /**
     * <p>
     * Constructor for Counter.</p>
     *
     * @param ringBuffer a {@link dom.jfischer.RingBuffer} object.
     * @param name a {@link java.lang.String} object.
     */
    public Counter(RingBuffer<String> ringBuffer, String name) {
        super(ringBuffer);
        this.name = name;
    }

    /**
     * <p>
     * run.</p>
     */
    public void run() {
        int counter = 0;

        while (!hasTerminated()) {
            String data = this.name + ":" + counter++;
            put(data);
        }

        System.out.println(
                "Counter(" + this.name + ") thread has reached its end.");

    }

}
