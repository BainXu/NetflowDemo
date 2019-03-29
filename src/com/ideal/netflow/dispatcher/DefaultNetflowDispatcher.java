package com.ideal.netflow.dispatcher;

import java.net.SocketException;
import java.util.LinkedList;

import org.apache.log4j.Logger;

import com.ideal.netflow.FlowRecordv5;
import com.ideal.netflow.NetFlowUtils;

/**
 * @author Bain Xu
 * 
 */
public class DefaultNetflowDispatcher implements NetflowDispatcher {
	private LinkedList<FlowRecordv5> queue = new LinkedList<FlowRecordv5>();
	private boolean closed = false;
	private int processorCount = 1;
	private Logger logger = Logger.getLogger(this.getClass());

	public DefaultNetflowDispatcher(int processorCount) {
		super();
		this.processorCount = processorCount;
	}

	public void close() {
		closed = true;
	}

	public void start() throws SocketException {
		closed = false;
		for (int i = 0; i < processorCount; i++) {
			new Processor().start();
		}
	}

	public void dispatch(Object data) {
		synchronized (queue) {
			queue.addLast((FlowRecordv5) data);
			queue.notifyAll();
		}
	}

	private class Processor extends Thread {
		FlowRecordv5 flowRecordv5 = null;

		public void run() {
			while (!closed) {
				synchronized (queue) {
					if (queue.size() > 0) {
						flowRecordv5 = queue.removeFirst();
					} else {
						try {
							queue.wait();
						} catch (InterruptedException e) {
							e.printStackTrace();
						}
					}
				}// synchronized
				if (flowRecordv5 != null) {
					process(flowRecordv5);
					flowRecordv5 = null;
				}
			}// while
		}// run

		private void process(FlowRecordv5 flowRecordv5) {

			String srcAddr = NetFlowUtils.long2ip(flowRecordv5.getSrcaddr());
			int srcPort = flowRecordv5.getSrcport();
			String dstAddr = NetFlowUtils.long2ip(flowRecordv5.getDstaddr());
			int dstPort = flowRecordv5.getDstport();
			int tos = flowRecordv5.getTos();
			int prot = flowRecordv5.getProt();
			long pkts = flowRecordv5.getPkts();
			long otets = flowRecordv5.getOctets();
			System.out.println(NetFlowUtils.format(srcAddr, 16) + NetFlowUtils.format(String.valueOf(srcPort), 7)
					+ NetFlowUtils.format(dstAddr, 16) + NetFlowUtils.format(String.valueOf(dstPort), 7)
					+ NetFlowUtils.format(String.valueOf(tos), 4) + NetFlowUtils.format(String.valueOf(prot), 5)
					+ NetFlowUtils.format(String.valueOf(pkts), 10)
					+ NetFlowUtils.format(String.valueOf(otets), 10));
			logger.info(NetFlowUtils.format(srcAddr, 16) + NetFlowUtils.format(String.valueOf(srcPort), 7)
					+ NetFlowUtils.format(dstAddr, 16) + NetFlowUtils.format(String.valueOf(dstPort), 7)
					+ NetFlowUtils.format(String.valueOf(tos), 4) + NetFlowUtils.format(String.valueOf(prot), 5)
					+ NetFlowUtils.format(String.valueOf(pkts), 10)
					+ NetFlowUtils.format(String.valueOf(otets), 10));
		}
	}
}
