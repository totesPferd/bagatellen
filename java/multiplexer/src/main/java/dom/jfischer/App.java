package dom.jfischer;

import dom.jfischer.sink.Sysout;
import dom.jfischer.source.Counter;

/**
 * <p>App class.</p>
 *
 * @author jfischer
 * @version $Id: $Id
 */
public class App 
{
    private static final RingBuffer<String> RING_BUFFER =  new RingBuffer<>(12);

    /**
     * <p>main.</p>
     *
     * @param args an array of {@link java.lang.String} objects.
     */
    public static void main( String[] args )
    {
        System.out.println("Ring buffer is running.");

        Source<String> counterA =  new Counter(RING_BUFFER, "A");
        Source<String> counterB =  new Counter(RING_BUFFER, "B");
        Source<String> counterC =  new Counter(RING_BUFFER, "C");
        Sink<String> sysoutA =  new Sysout(RING_BUFFER, "a");
        Sink<String> sysoutB =  new Sysout(RING_BUFFER, "b");
        Sink<String> sysoutC =  new Sysout(RING_BUFFER, "c");
        Sink<String> sysoutD =  new Sysout(RING_BUFFER, "d");
        Sink<String> sysoutE =  new Sysout(RING_BUFFER, "e");

        counterA.start();
        counterB.start();
        counterC.start();

        RING_BUFFER.addSink(sysoutA);
        RING_BUFFER.addSink(sysoutB);
        RING_BUFFER.addSink(sysoutC);
        RING_BUFFER.addSink(sysoutD);
        RING_BUFFER.addSink(sysoutE);

        try {
            Thread.sleep(20736);
        } catch (Exception e) {
            System.err.println(
                    "Problem right before terminating ring buffer: "
                  + e.getMessage() );
        }
        RING_BUFFER.terminate();
        System.out.println( "Ring buffer has been terminated." );

        try {
            counterA.join();
            counterB.join();
            counterC.join();
            RING_BUFFER.joinSinks();
        } catch (Exception e) {
            System.err.println(
                    "Problem right after terminating ring buffer: "
                  + e.getMessage() );
        }

        System.out.println("all threads joined.");

    }
}
