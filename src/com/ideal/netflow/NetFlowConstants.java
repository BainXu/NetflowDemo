package com.ideal.netflow;

/**
 * @author Bain Xu
 *
 */
public class NetFlowConstants {

	public static final int NETFLOW_V5_PACKET_HEADER_LENGTH = 24;
	public static final int NETFLOW_V5_PACKET_FLOW_RECORD_LENGTH = 48;
	public static final int NETFLOW_V5_PACKET_MAX_FLOW_RECORDS = 30;
	public static final int NETFLOW_V5_PACKET_MAX_LENGTH = NETFLOW_V5_PACKET_HEADER_LENGTH
			+ NETFLOW_V5_PACKET_MAX_FLOW_RECORDS * NETFLOW_V5_PACKET_FLOW_RECORD_LENGTH;
	public static final int NETFLOW_V5_PACKET_MIN_LENGTH = NETFLOW_V5_PACKET_HEADER_LENGTH
			+ NETFLOW_V5_PACKET_FLOW_RECORD_LENGTH;

	public static final byte NETFLOW_V5_FLOW_COUNT_POSITION = 0x03;
	public static final byte NETFLOW_V5_FLOW_SRCADDR_POSITION = 0x00;
	public static final byte NETFLOW_V5_FLOW_DSTADDR_POSITION = 0x04;
	public static final byte NETFLOW_V5_FLOW_NEXTHOP_POSITION = 0x08;
	public static final byte NETFLOW_V5_FLOW_INPUT_POSITION = 0x0C;
	public static final byte NETFLOW_V5_FLOW_OUTPUT_POSITION = 0x0E;
	public static final byte NETFLOW_V5_FLOW_PKTS_POSITION = 0x10;
	public static final byte NETFLOW_V5_FLOW_OCTETS_POSITION = 0x14;
	public static final byte NETFLOW_V5_FLOW_FIRST_POSITION = 0x18;
	public static final byte NETFLOW_V5_FLOW_LAST_POSITION = 0x1C;
	public static final byte NETFLOW_V5_FLOW_SRCPORT_POSITION = 0x20;
	public static final byte NETFLOW_V5_FLOW_DSTPORT_POSITION = 0x22;
	public static final byte NETFLOW_V5_FLOW_FLAGS_POSITION = 0x25;
	public static final byte NETFLOW_V5_FLOW_PROT_POSITION = 0x26;
	public static final byte NETFLOW_V5_FLOW_TOS_POSITION = 0x27;
	public static final byte NETFLOW_V5_FLOW_SRCAS_POSITION = 0x28;
	public static final byte NETFLOW_V5_FLOW_DSTAS_POSITION = 0x2A;
	public static final byte NETFLOW_V5_FLOW_SRCMASK_POSITION = 0x2C;
	public static final byte NETFLOW_V5_FLOW_DSTMASK_POSITION = 0x2D;

	public NetFlowConstants() {
		super();
	}
}
