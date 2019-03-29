package com.ideal.netflow.receiver;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;
import java.util.Date;

import org.apache.log4j.Logger;

import com.ideal.netflow.FlowRecordv5;
import com.ideal.netflow.NetFlowConstants;
import com.ideal.netflow.NetFlowUtils;
import com.ideal.netflow.dispatcher.NetflowDispatcher;

/**
 * 
 * The net flow v5 datagram consists of a header and one or more flow records.
 * The first field of the header contains the version number of the export
 * datagram. Typically, a receiving application that accepts any of the format
 * versions allocates a buffer large enough for the largest possible datagram
 * from any of the format versions and then uses the header to determine how to
 * interpret the datagram. The second field in the header contains the number of
 * records in the datagram and should be used to search through the records
 * 
 * @author Bain Xu
 * 
 */
public class DefaultNetflowReceiver implements NetflowReceiver {
	boolean closed = false;

	private DatagramSocket datagramSocket = null;
	private DatagramPacket datagramPacket = null;
	private byte[] buffer = null;
	private NetflowDispatcher netflowDispatcher = null;
	private Logger logger = Logger.getLogger(this.getClass());
	private int lisenPort = 40000;

	public DefaultNetflowReceiver(int lisenPort) {
		super();
		this.lisenPort = lisenPort;
	}

	/*
	 * @see com.ideal.netflow.receiver.NetflowReceiver#setNetflowDispatcher(com.ideal.netflow.dispatcher.NetflowDispatcher)
	 */
	public void setNetflowDispatcher(NetflowDispatcher netflowDispatcher) {
		this.netflowDispatcher = netflowDispatcher;
	}

	/*
	 * @see com.ideal.netflow.receiver.NetflowReceiver#start()
	 */
	public void start() throws SocketException {
		closed = false;
		buffer = new byte[NetFlowConstants.NETFLOW_V5_PACKET_MAX_LENGTH];
		datagramSocket = new DatagramSocket(lisenPort);
		datagramPacket = new DatagramPacket(buffer, buffer.length);
		new Thread(this).start();
		System.out.println(new Date(System.currentTimeMillis()) + " Netflow receiver started at address:" + lisenPort);
	}

	public void run() {
		int actualLength = 0;
		int flowCount = 0;
		int index = 0;
		int flowPostion = 0;
		int pointer = 0;
		FlowRecordv5 flowRecordv5 = null;
		@SuppressWarnings("unused")
		String targetIp = null;
		while (!closed) {
			try {
				datagramSocket.receive(datagramPacket);
				targetIp = datagramPacket.getAddress().getHostAddress();

				actualLength = datagramPacket.getLength();
				/*
				 * Check the size of the datagram to verify that it is at least
				 * long enough to contain the version and count fields.
				 */
				if (actualLength < NetFlowConstants.NETFLOW_V5_PACKET_MIN_LENGTH || actualLength > NetFlowConstants.NETFLOW_V5_PACKET_MAX_LENGTH) {
					continue;
				}
				printHeaderLine();

				flowCount = buffer[NetFlowConstants.NETFLOW_V5_FLOW_COUNT_POSITION];
				for (index = 0; index < flowCount && index < NetFlowConstants.NETFLOW_V5_PACKET_MAX_FLOW_RECORDS; index++) {
					flowPostion = NetFlowConstants.NETFLOW_V5_PACKET_HEADER_LENGTH + index * NetFlowConstants.NETFLOW_V5_PACKET_FLOW_RECORD_LENGTH;
					flowRecordv5 = new FlowRecordv5();
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_SRCADDR_POSITION;
					flowRecordv5.setSrcaddr(NetFlowUtils.to4byteLong(buffer, pointer));
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_DSTADDR_POSITION;
					flowRecordv5.setDstaddr(NetFlowUtils.to4byteLong(buffer, pointer));
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_NEXTHOP_POSITION;
					flowRecordv5.setNexthop(NetFlowUtils.to4byteLong(buffer, pointer));
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_INPUT_POSITION;
					flowRecordv5.setInputIfIndex(NetFlowConstants.NETFLOW_V5_FLOW_INPUT_POSITION);
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_OUTPUT_POSITION;
					flowRecordv5.setOutputIfIndex(NetFlowConstants.NETFLOW_V5_FLOW_OUTPUT_POSITION);
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_PKTS_POSITION;
					flowRecordv5.setPkts(NetFlowUtils.to4byteLong(buffer, pointer));
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_OCTETS_POSITION;
					flowRecordv5.setOctets(NetFlowUtils.to4byteLong(buffer, pointer));
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_FIRST_POSITION;
					flowRecordv5.setFirst(NetFlowUtils.to4byteLong(buffer, pointer));
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_LAST_POSITION;
					flowRecordv5.setLast(NetFlowUtils.to4byteLong(buffer, pointer));
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_SRCPORT_POSITION;
					flowRecordv5.setSrcport(NetFlowUtils.to2byteInt(buffer, pointer));
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_DSTPORT_POSITION;
					flowRecordv5.setDstport(NetFlowUtils.to2byteInt(buffer, pointer));
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_FLAGS_POSITION;
					flowRecordv5.setTcp_flags(buffer[pointer] & 0xFF);
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_PROT_POSITION;
					flowRecordv5.setProt(buffer[pointer] & 0xFF);
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_TOS_POSITION;
					flowRecordv5.setTos(buffer[pointer] & 0xFF);
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_SRCAS_POSITION;
					flowRecordv5.setSrc_as(NetFlowUtils.to2byteInt(buffer, pointer));
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_DSTAS_POSITION;
					flowRecordv5.setDst_as(NetFlowUtils.to2byteInt(buffer, pointer));
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_SRCMASK_POSITION;
					flowRecordv5.setSrc_mask(buffer[pointer] & 0xFF);
					pointer = flowPostion + NetFlowConstants.NETFLOW_V5_FLOW_DSTMASK_POSITION;
					flowRecordv5.setDst_mask(buffer[pointer] & 0xFF);
					netflowDispatcher.dispatch(flowRecordv5);
				} // for

			} catch (IOException e) {
				e.printStackTrace(System.err);
			}
		}
	}

	private void printHeaderLine() {
		logger.info("\n");
		logger.info(NetFlowUtils.format("Src_Address", 16) + NetFlowUtils.format("SPort", 7) + NetFlowUtils.format("Dst_Address", 16) + NetFlowUtils.format(String.valueOf("DPort"), 7) + NetFlowUtils.format("TOS", 4) + NetFlowUtils.format("Prot", 5)
				+ NetFlowUtils.format("Packets", 10) + NetFlowUtils.format("Octets", 10));
		System.out.print("\n");
		System.out.println(NetFlowUtils.format("Src_Address", 16) + NetFlowUtils.format("SPort", 7) + NetFlowUtils.format("Dst_Address", 16) + NetFlowUtils.format(String.valueOf("DPort"), 7) + NetFlowUtils.format("TOS", 4)
				+ NetFlowUtils.format("Prot", 5) + NetFlowUtils.format("Packets", 10) + NetFlowUtils.format("Octets", 10));
	}

	/*
	 * @see com.ideal.netflow.receiver.NetflowReceiver#close()
	 */
	public void close() {
		closed = true;
	}
}
