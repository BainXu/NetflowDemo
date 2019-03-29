package com.ideal.netflow.dispatcher;

import java.net.SocketException;

/**
 * @author Bain Xu
 *
 */
public interface NetflowDispatcher {
	/**
	 * @param data
	 *            Object.
	 */
	void dispatch(Object data);

	/**
	 * Turn on Dispatcher.
	 * 
	 * @throws SocketException
	 */
	void start() throws SocketException;

	/**
	 * Turn off Dispatcher.
	 */
	void close();
}
