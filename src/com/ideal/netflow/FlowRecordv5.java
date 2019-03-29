package com.ideal.netflow;

import java.io.Serializable;

/**
 * @author Bain Xu
 *
 */
public class FlowRecordv5 implements Serializable {

	private static final long serialVersionUID = 1L;

	private long srcaddr;
	private long dstaddr;
	private long nexthop;
	private int inputIfIndex;
	private int outputIfIndex;
	private long pkts;
	private long octets;
	private long first;
	private long last;
	private int srcport;
	private int dstport;
	private int tcp_flags;
	private int prot;
	private int tos;
	private int src_as;
	private int dst_as;
	private int src_mask;
	private int dst_mask;

	public long getSrcaddr() {
		return srcaddr;
	}

	public void setSrcaddr(long srcaddr) {
		this.srcaddr = srcaddr;
	}

	public long getDstaddr() {
		return dstaddr;
	}

	public void setDstaddr(long dstaddr) {
		this.dstaddr = dstaddr;
	}

	public long getNexthop() {
		return nexthop;
	}

	public void setNexthop(long nexthop) {
		this.nexthop = nexthop;
	}

	public int getInputIfIndex() {
		return inputIfIndex;
	}

	public void setInputIfIndex(int inputIfIndex) {
		this.inputIfIndex = inputIfIndex;
	}

	public int getOutputIfIndex() {
		return outputIfIndex;
	}

	public void setOutputIfIndex(int outputIfIndex) {
		this.outputIfIndex = outputIfIndex;
	}

	public long getPkts() {
		return pkts;
	}

	public void setPkts(long pkts) {
		this.pkts = pkts;
	}

	public long getOctets() {
		return octets;
	}

	public void setOctets(long octets) {
		this.octets = octets;
	}

	public long getFirst() {
		return first;
	}

	public void setFirst(long first) {
		this.first = first;
	}

	public long getLast() {
		return last;
	}

	public void setLast(long last) {
		this.last = last;
	}

	public int getSrcport() {
		return srcport;
	}

	public void setSrcport(int srcport) {
		this.srcport = srcport;
	}

	public int getDstport() {
		return dstport;
	}

	public void setDstport(int dstport) {
		this.dstport = dstport;
	}

	public int getTcp_flags() {
		return tcp_flags;
	}

	public void setTcp_flags(int tcp_flags) {
		this.tcp_flags = tcp_flags;
	}

	public int getProt() {
		return prot;
	}

	public void setProt(int prot) {
		this.prot = prot;
	}

	public int getTos() {
		return tos;
	}

	public void setTos(int tos) {
		this.tos = tos;
	}

	public int getSrc_as() {
		return src_as;
	}

	public void setSrc_as(int src_as) {
		this.src_as = src_as;
	}

	public int getDst_as() {
		return dst_as;
	}

	public void setDst_as(int dst_as) {
		this.dst_as = dst_as;
	}

	public long getSrc_mask() {
		return src_mask;
	}

	public void setSrc_mask(int src_mask) {
		this.src_mask = src_mask;
	}

	public long getDst_mask() {
		return dst_mask;
	}

	public void setDst_mask(int dst_mask) {
		this.dst_mask = dst_mask;
	}
}
