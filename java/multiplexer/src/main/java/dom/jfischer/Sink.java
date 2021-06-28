package dom.jfischer;

import java.util.concurrent.locks.Lock;

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

    private boolean isEmpty =  true;

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

    public boolean isEmpty() {
       return this.isEmpty;
    }

    public void setIsEmpty(boolean value) {
       this.isEmpty =  value;
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
        Lock lock = this.ringBuffer.getLock();

        T retval = null;

        lock.lock();
        try {
            if (!this.ringBuffer.waitTilItsNotEmpty(this)) {
                retval = this.ringBuffer.getItem(this);
            }
            this.ringBuffer.debug("get");
        } finally {
            lock.unlock();
        }
        return retval;
    }

}
