package com.ideal.netflow.simulator;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.UnknownHostException;

import com.ideal.netflow.NetFlowConstants;
import com.ideal.netflow.NetFlowUtils;

public class NetflowSimulator implements Runnable {
	private boolean closed = false;
	//发送方IP
	private String targetIP = "172.31.101.11";
	private InetAddress targetAddress = null;
	private int targetPort = 39000;

	private DatagramSocket socket = null;
	private int messageSequence = 0;

	public void start(String[] args) throws SocketException, UnknownHostException {
		socket = new DatagramSocket();
		try {
//			targetIP = args[0];
//			targetPort = Integer.parseInt(args[1]);
		} catch (NumberFormatException e) {
		}
		targetAddress = InetAddress.getByName(targetIP);
		new Thread(this).start();
		System.out.println("Simulator started.");
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		NetflowSimulator simulator = new NetflowSimulator();
		try {
			simulator.start(args);
		} catch (SocketException e) {
			// TODO Auto-generated catch block
			e.printStackTrace(System.err);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace(System.err);
		}
		// TODO Auto-generated catch block

	}

	private byte[] constructPacket() {
		int flowCount = (int) (30 * Math.random());
		if (flowCount < 1) {
			flowCount = 1;
		} else if (flowCount > NetFlowConstants.NETFLOW_V5_PACKET_MAX_FLOW_RECORDS) {
			flowCount = NetFlowConstants.NETFLOW_V5_PACKET_MAX_FLOW_RECORDS;
		}
		byte[] packet = new byte[0];
		messageSequence += flowCount;
		byte[] header = constructHeader(flowCount, messageSequence);
		packet = concatBytes(packet, header);
		for (int i = 1; i <= flowCount; i++) {
			byte[] flow = constructFlow();
			packet = concatBytes(packet, flow);
		}
		return packet;
	}

	private byte[] constructHeader(int flowCount, int flowSequence) {
		byte[] header = new byte[NetFlowConstants.NETFLOW_V5_PACKET_HEADER_LENGTH];
		// version
		header[0] = 0x00;
		header[1] = 0x05;
		// count
		header[2] = 0x00;
		header[3] = NetFlowUtils.getByte(flowCount, 1);
		// sysUptime
		long time = System.currentTimeMillis();
		header[4] = NetFlowUtils.getByte(time, 4);
		header[5] = NetFlowUtils.getByte(time, 3);
		header[6] = NetFlowUtils.getByte(time, 2);
		header[7] = NetFlowUtils.getByte(time, 1);
		// flow sequence
		header[16] = NetFlowUtils.getByte(flowSequence, 4);
		header[17] = NetFlowUtils.getByte(flowSequence, 3);
		header[18] = NetFlowUtils.getByte(flowSequence, 2);
		header[19] = NetFlowUtils.getByte(flowSequence, 1);
		return header;
	}

	private byte[] constructFlow() {
		byte[] flow = new byte[NetFlowConstants.NETFLOW_V5_PACKET_FLOW_RECORD_LENGTH];
		// source ip address
		flow[0] = (byte) ((-128) * Math.random());
		flow[1] = (byte) ((-128) * Math.random());
		flow[2] = (byte) ((-128) * Math.random());
		flow[3] = (byte) ((-128) * Math.random());
		// destination ip address
		flow[4] = (byte) ((-128) * Math.random());
		flow[5] = (byte) ((-128) * Math.random());
		flow[6] = (byte) ((-128) * Math.random());
		flow[7] = (byte) ((-128) * Math.random());
		// next hop
		flow[8] = (byte) ((-128) * Math.random());
		flow[9] = (byte) ((-128) * Math.random());
		flow[10] = (byte) ((-128) * Math.random());
		flow[11] = (byte) ((-128) * Math.random());
		// input (12,13)
		flow[12] = 0;
		flow[13] = (byte) ((-128) * Math.random());
		// outut(14,15)
		flow[14] = 0;
		flow[15] = (byte) ((-128) * Math.random());
		// dpkts
		flow[16] = 0;
		flow[17] = (byte) (127 * Math.random());
		flow[18] = (byte) (127 * Math.random());
		flow[19] = (byte) (127 * Math.random());
		// dotets
		flow[20] = (byte) ((-128) * Math.random());
		flow[21] = (byte) ((-128) * Math.random());
		flow[22] = (byte) ((-128) * Math.random());
		flow[23] = (byte) ((-128) * Math.random());
		// first
		long first = System.currentTimeMillis();
		flow[24] = NetFlowUtils.getByte(first, 4);
		flow[25] = NetFlowUtils.getByte(first, 3);
		flow[26] = NetFlowUtils.getByte(first, 2);
		flow[27] = NetFlowUtils.getByte(first, 1);
		// last
		long last = System.currentTimeMillis();
		flow[28] = NetFlowUtils.getByte(last, 4);
		flow[29] = NetFlowUtils.getByte(last, 3);
		flow[30] = NetFlowUtils.getByte(last, 2);
		flow[31] = NetFlowUtils.getByte(last, 1);
		// src port
		flow[32] = (byte) (127 * Math.random());
		flow[33] = (byte) (127 * Math.random());
		// dest port
		flow[34] = (byte) (127 * Math.random());
		flow[35] = (byte) (127 * Math.random());
		// tcp_flags
		flow[37] = (byte) (127 * Math.random());
		// prot
		flow[38] = (byte) (100 * Math.random());
		// tos
		flow[39] = (byte) (100 * Math.random());
		// src_as
		flow[40] = (byte) ((-128) * Math.random());
		flow[41] = (byte) ((-128) * Math.random());
		// dst_as
		flow[42] = (byte) ((-128) * Math.random());
		flow[43] = (byte) ((-128) * Math.random());
		// src_mask
		flow[44] = (byte) ((-128) * Math.random());
		// dst_mask
		flow[45] = (byte) ((-128) * Math.random());

		return flow;
	}

	public static byte[] concatBytes(byte[] a, byte[] b) {
		byte[] rs = new byte[a.length + b.length];
		System.arraycopy(a, 0, rs, 0, a.length);
		System.arraycopy(b, 0, rs, a.length, b.length);
		return rs;
	}

	public void run() {
		while (!closed) {
			byte[] netflow = constructPacket();
			DatagramPacket packet = new DatagramPacket(netflow, netflow.length, targetAddress, targetPort);
			System.out.println(packet.getAddress());
			try {
				socket.send(packet);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace(System.err);
			}
			try {
				Thread.sleep(10 * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}// while
	}// run

}
