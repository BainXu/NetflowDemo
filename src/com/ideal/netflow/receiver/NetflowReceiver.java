package com.ideal.netflow.receiver;

import java.net.SocketException;

import com.ideal.netflow.dispatcher.NetflowDispatcher;

/**
 * @author Bain Xu
 *
 */
public interface NetflowReceiver extends Runnable {
	/**
	 * @param netflowDispatcher
	 *            NetflowDispatcher.
	 */
	void setNetflowDispatcher(NetflowDispatcher netflowDispatcher);

	/**
	 * Turn on receiver.
	 * 
	 * @throws SocketException
	 */
	void start() throws SocketException;

	/**
	 * Turn off receiver.
	 */
	void close();
}
