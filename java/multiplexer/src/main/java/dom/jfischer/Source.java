package dom.jfischer;

import java.util.concurrent.locks.Lock;

/**
 * <p>Source class.</p>
 *
 * @author jfischer
 * @version $Id: $Id
 */
public class Source<T> extends Thread {

    private final RingBuffer<T> ringBuffer;

    /**
     * <p>Constructor for Source.</p>
     *
     * @param ringBuffer a {@link dom.jfischer.RingBuffer} object.
     */
    public Source(RingBuffer<T> ringBuffer) {
        this.ringBuffer = ringBuffer;
    }

    /**
     * <p>put.</p>
     *
     * @param data a T object.
     */
    protected void put(T data) {
        Lock lock =  this.ringBuffer.getLock();

        lock.lock();
        try {
            this.ringBuffer.waitTilItsNotFull();
            this.ringBuffer.setItem(data);
        } finally {
            lock.unlock();
        }
    }

    /**
     * <p>hasTerminated.</p>
     *
     * @return a boolean.
     */
    protected boolean hasTerminated() {
        return this.ringBuffer.hasTerminated();
    }

}
