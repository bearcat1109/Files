//BufferImpl.java
import java.util.ArrayList;
public class BufferImpl<E> implements Buffer<E>
{
	public static final int BUFFER_SIZE = 5;
	private ArrayList<E> elements;
	private int in, out, count;

	public BufferImpl() {
		count = 0;
		in = 0;
		out = 0;

		elements = new ArrayList<>(BUFFER_SIZE);
	}

	// value-pass constructor to requirements(If I understand them correctly)
	public BufferImpl(int count, int in, int out, int BUFFER_SIZE)
	{
		
        BufferImpl.count = count;
        BufferImpl.in = in;
        BufferImpl.out = out;
        BufferImpl.elements = new ArrayList<>(BUFFER_SIZE);
	}


	// producers call this method
	public void insert(E item) {
		while (count == BUFFER_SIZE)
			; // do nothing -- no free space

		// add an element to the buffer
		elements.add(in, item);
		in = (in + 1) % BUFFER_SIZE;
		++count;
	}

	// consumers call this method
	public E remove() {
		E item;

		while (count == 0)
			; // do nothing - nothing to consume

		// remove an item from the buffer
		item = elements.get(out);
		out = (out + 1) % BUFFER_SIZE;
		--count;

		return item;
	}
}
