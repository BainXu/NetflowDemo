package com.ideal.netflow;

import java.util.Hashtable;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

public class LoggerFactory {
	private static final Hashtable<String, Logger> loggerList = new Hashtable<String, Logger>();

	public static Logger getLogger(Class<?> c) {
		Logger log = loggerList.get(c.getName());
		if (log == null) {
			log = Logger.getLogger(c);
			loggerList.put(c.getName(), log);
		}
		return log;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	static {
		PropertyConfigurator.configure("config/log4j.properties");
	}
}
