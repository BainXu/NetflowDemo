package com.ideal.netflow;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
public class Test {
	/**
	 * DatagramSocket(int port)
	 * DatagramPacket(byte[] buf, int length)  构造 DatagramPacket，用来接收长度为 length 的数据包。
	 * DataPacket类中方法:
	 *     getData() 返回数据缓冲区。
	 *  getLength()返回将要发送或接收到的数据的长度。
	 *  getPort() 返回某台远程主机的端口号，此数据报将要发往该主机或者是从该主机接收到的
	 *  getAddress()返回某台机器的 IP 地址，此数据报将要发往该机器或者是从该机器接收到的。
	 * 
	 */
	    public static void main(String[] args) {
	        try {
	            //1.创建数据报套接字
	            DatagramSocket socket = new DatagramSocket(9999);
	            //2.创建一个数据报包
	            byte[] content = new byte[1024];
	            DatagramPacket datagramPacket = new DatagramPacket(content,content.length,InetAddress.getLocalHost(),8888);
	            //3.调用receive方法接收数据包
	            try {  
	                //设置超时时间,2秒  
	            	socket.setSoTimeout(2000);  
	                socket.receive(datagramPacket); 
	            } catch (Exception e) {  
	                e.printStackTrace();
	            }  
	            
	            //4.从数据报包中获取数据
	            byte[] data=  datagramPacket.getData();//获取数据报包中的数据
	            int length = datagramPacket.getLength();//
	            InetAddress ip = datagramPacket.getAddress();
	            int port = datagramPacket.getPort();
	            System.out.println("内容:"+new String(data,0,length));
	            System.out.println("数据长度:"+length);
	            System.out.println("发送方的IP地址:"+ip);
	            System.out.println("发送方的端口号:"+port);
	            //5.释放资源
	            socket.close();
	        } catch (SocketException e) {
	            e.printStackTrace();
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	        
	    }
}
