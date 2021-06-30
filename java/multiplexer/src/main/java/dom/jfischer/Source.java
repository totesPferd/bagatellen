package dom.jfischer;

/**
 * <p>
 * Source class.</p>
 *
 * @author jfischer
 * @version $Id: $Id
 * @param <T>
 */
public class Source<T> extends Thread {

    private final RingBuffer<T> ringBuffer;

    /**
     * <p>
     * Constructor for Source.</p>
     *
     * @param ringBuffer a {@link dom.jfischer.RingBuffer} object.
     */
    public Source(RingBuffer<T> ringBuffer) {
        this.ringBuffer = ringBuffer;
    }

    /**
     * <p>
     * put.</p>
     *
     * @param data a T object.
     */
    protected void put(T data) {
        this.ringBuffer.put(data);
    }

    /**
     * <p>
     * hasTerminated.</p>
     *
     * @return a boolean.
     */
    protected boolean hasTerminated() {
        return this.ringBuffer.hasTerminated();
    }

}
