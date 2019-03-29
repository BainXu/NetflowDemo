package com.ideal.netflow;

import java.io.FileInputStream;
import java.util.Date;
import java.util.Properties;

import com.ideal.netflow.dispatcher.DefaultNetflowDispatcher;
import com.ideal.netflow.dispatcher.NetflowDispatcher;
import com.ideal.netflow.receiver.DefaultNetflowReceiver;
import com.ideal.netflow.receiver.NetflowReceiver;

/**
 * @author Bain Xu
 * 
 */
public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			FileInputStream fin = new FileInputStream("config/config.properties");
			Properties prop = new Properties();
			prop.load(fin);
			fin.close();
			int port = Integer.parseInt(prop.getProperty("port", "40000"));
			System.out.println(new Date(System.currentTimeMillis()) + " Netflow server starting.");
			NetflowDispatcher dispatcher = new DefaultNetflowDispatcher(1);
			dispatcher.start();
			NetflowReceiver receiver = new DefaultNetflowReceiver(port);
			receiver.setNetflowDispatcher(dispatcher);
			receiver.start();
			System.out.println(new Date(System.currentTimeMillis()) + " Netflow server started.");
		} catch (Exception e) {
			e.printStackTrace(System.err);
		}
	}
}
