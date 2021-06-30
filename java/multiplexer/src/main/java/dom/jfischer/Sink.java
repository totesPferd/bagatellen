package dom.jfischer;

/**
 * <p>
 * Sink class.</p>
 *
 * @author jfischer
 * @version $Id: $Id
 * @param <T>
 */
public class Sink<T> extends Thread {

    private final RingBuffer<T> ringBuffer;
    private final Pointer readPointer;

    /**
     * <p>
     * Constructor for Sink.</p>
     *
     * @param ringBuffer a {@link dom.jfischer.RingBuffer} object.
     */
    public Sink(RingBuffer ringBuffer) {
        this.ringBuffer = ringBuffer;
        this.readPointer = new Pointer(ringBuffer.getCapacity());
    }

    /**
     * <p>
     * Getter for the field <code>readPointer</code>.</p>
     *
     * @return a {@link dom.jfischer.Pointer} object.
     */
    public Pointer getReadPointer() {
        return this.readPointer;
    }

    /**
     * <p>
     * get.</p>
     *
     * @return a T object.
     */
    protected T get() {
        return this.ringBuffer.get(this);
    }

}
