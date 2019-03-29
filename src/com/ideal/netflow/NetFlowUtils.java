package com.ideal.netflow;

import java.util.StringTokenizer;

/**
 * @author Bain Xu
 * 
 */
public class NetFlowUtils {
	static final long[] LONGS = { 0x8000000000000000L, 0x4000000000000000L, 0x2000000000000000L, 0x1000000000000000L,
			0x0800000000000000L, 0x0400000000000000L, 0x0200000000000000L, 0x0100000000000000L, 0x0080000000000000L,
			0x0040000000000000L, 0x0020000000000000L, 0x0010000000000000L, 0x0008000000000000L, 0x0004000000000000L,
			0x0002000000000000L, 0x0001000000000000L, 0x0000800000000000L, 0x0000400000000000L, 0x0000200000000000L,
			0x0000100000000000L, 0x0000080000000000L, 0x0000040000000000L, 0x0000020000000000L, 0x0000010000000000L,
			0x0000008000000000L, 0x0000004000000000L, 0x0000002000000000L, 0x0000001000000000L, 0x0000000800000000L,
			0x0000000400000000L, 0x0000000200000000L, 0x0000000100000000L, 0x0000000080000000L, 0x0000000040000000L,
			0x0000000020000000L, 0x0000000010000000L, 0x0000000008000000L, 0x0000000004000000L, 0x0000000002000000L,
			0x0000000001000000L, 0x0000000000800000L, 0x0000000000400000L, 0x0000000000200000L, 0x0000000000100000L,
			0x0000000000080000L, 0x0000000000040000L, 0x0000000000020000L, 0x0000000000010000L, 0x0000000000008000L,
			0x0000000000004000L, 0x0000000000002000L, 0x0000000000001000L, 0x0000000000000800L, 0x0000000000000400L,
			0x0000000000000200L, 0x0000000000000100L, 0x0000000000000080L, 0x0000000000000040L, 0x0000000000000020L,
			0x0000000000000010L, 0x0000000000000008L, 0x0000000000000004L, 0x0000000000000002L, 0x0000000000000001L };

	static final int[] INTS = { 0x80000000, 0x40000000, 0x20000000, 0x10000000, 0x08000000, 0x04000000, 0x02000000, 0x01000000,
			0x00800000, 0x00400000, 0x00200000, 0x00100000, 0x00080000, 0x00040000, 0x00020000, 0x00010000, 0x00008000,
			0x00004000, 0x00002000, 0x00001000, 0x00000800, 0x00000400, 0x00000200, 0x00000100, 0x00000080, 0x00000040,
			0x00000020, 0x00000010, 0x00000008, 0x00000004, 0x00000002, 0x00000001 };

	static final byte[] BYTES = { (byte) 0x80, (byte) 0x40, (byte) 0x20, (byte) 0x10, (byte) 0x08, (byte) 0x04, (byte) 0x02,
			(byte) 0x01 };

	public static long byte2long(byte b) {
		return b & 0xFFL;
	}

	public static int byte2int(byte b) {
		return b & 0xFF;
	}

	public static byte getByte(int value, int index) {
		switch (index) {
		case 1:
			return (byte) (value & 0xFF);
		case 2:
			return (byte) ((value & 0xFF00) >> 8);
		case 3:
			return (byte) ((value & 0xFF0000) >> 16);
		case 4:
			return (byte) ((value & 0xFF000000) >> 24);
		default:
			return 0;
		}
	}

	public static byte getByte(long value, int index) {
		switch (index) {
		case 1:
			return (byte) (value & 0xFFL);
		case 2:
			return (byte) ((value & 0xFF00L) >> 8);
		case 3:
			return (byte) ((value & 0xFF0000L) >> 16);
		case 4:
			return (byte) ((value & 0xFF000000L) >> 24);
		case 5:
			return (byte) ((value & 0xFF00000000L) >> 32);
		case 6:
			return (byte) ((value & 0xFF0000000000L) >> 40);
		case 7:
			return (byte) ((value & 0xFF000000000000L) >> 48);
		case 8:
			return (byte) ((value & 0xFF00000000000000L) >> 56);
		default:
			return 0;
		}
	}

	public static long to4byteLong(byte[] buffer, int offset) {
		return ((buffer[offset] & 0xFFL) << 24) | ((buffer[offset + 1] & 0xFFL) << 16) | ((buffer[offset + 2] & 0xFFL) << 8)
				| (buffer[offset + 3] & 0xFFL);
	}

	public static int toInt(byte[] buffer, int offset) {
		return ((buffer[offset] & 0xFF) << 24) | ((buffer[offset + 1] & 0xFF) << 16) | ((buffer[offset + 2] & 0xFF) << 8)
				| (buffer[offset + 3] & 0xFF);
	}

	public static int to2byteInt(byte[] buffer, int pos) {
		return ((buffer[pos] & 0xFF) << 8) | (buffer[pos + 1] & 0xFF);
	}

	public static String long2ip(long ip) {
		StringBuffer sb = new StringBuffer();
		sb.append((ip & 0xFF000000L) >> 24);
		sb.append(".");
		sb.append((ip & 0xFF0000L) >> 16);
		sb.append(".");
		sb.append((ip & 0xFF00L) >> 8);
		sb.append(".");
		sb.append(ip & 0xFFL);
		return sb.toString();
	}

	public static long ip2long(String ip) {
		StringTokenizer stier = new StringTokenizer(ip, ".");
		long[] ary = new long[4];
		for (int i = 0; i < ary.length; i++) {
			ary[i] = Integer.parseInt(stier.nextToken());
		}
		return (ary[0] << 24) | (ary[1] << 16) | (ary[2] << 8) | ary[3];
	}

	/**
	 * Translate a long digit to binary sequence.
	 */
	public static String toBinaryString(long value) {
		StringBuffer sb = new StringBuffer(32);
		for (int i = 0; i < 64; i++) {
			long tmp = value;
			tmp = tmp & LONGS[i];
			if (tmp != 0) {
				sb.append("1");
			} else {
				sb.append("0");
			}
			if ((i + 1) % 8 == 0) {
				sb.append(" ");
			}
		}
		return sb.toString();
	}

	/**
	 * Translate a integer digit to binary sequence.
	 */
	public static String toBinaryString(int value) {
		StringBuffer sb = new StringBuffer(32);
		for (int i = 0; i < 32; i++) {
			int tmp = value;
			tmp = tmp & INTS[i];
			if (tmp != 0) {
				sb.append("1");
			} else {
				sb.append("0");
			}
			if ((i + 1) % 8 == 0) {
				sb.append(" ");
			}
		}
		return sb.toString();
	}

	/**
	 * Translate a byte to binary sequence.
	 */
	public static String toBinaryString(byte value) {
		StringBuffer sb = new StringBuffer(32);
		for (int i = 0; i < 8; i++) {
			byte tmp = value;
			tmp = (byte) (tmp & BYTES[i]);
			if (tmp != 0) {
				sb.append("1");
			} else {
				sb.append("0");
			}
		}
		return sb.toString();
	}

	public static String format(String s, int length) {
		StringBuffer sb = new StringBuffer();
		if (s != null) {
			sb.append(s);
		}
		int tobeAppended = length - sb.length();
		for (int i = 0; i < tobeAppended; i++) {
			sb.append(" ");
		}
		return sb.toString();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String ip = "254.10.202.10";
		long a = ip2long(ip);
		String myIp = long2ip(a);
		System.out.println(a);
		System.out.println(myIp);
	}
}
