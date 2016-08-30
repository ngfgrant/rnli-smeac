package pager;

import model.Contact;
import model.PagerMessage;
import services.SmsService;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.sql.Timestamp;

/**
 * Created by niallgrant on 13/08/16.
 */
public class UdpServer {

    public void init(PagerMessage pagerMessage) throws Exception {
        DatagramSocket serverSocket = new DatagramSocket(9876);
        byte[] receiveData = new byte[1024];
        byte[] sendData = new byte[1024];
        while (true) {
            try {
                DatagramPacket receivePacket = initialUdpServer(serverSocket,receiveData, sendData);
                String fullPagerMessage = captureFullPagerMessage(receivePacket);
                PagerMessage page = new PagerMessage(setTimestamp(), fullPagerMessage);
                addToPagerMessageList(page, pagerMessage);
                sendSMSMessages(page);
                sendData = fullPagerMessage.getBytes();
                System.out.println(fullPagerMessage);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private DatagramPacket initialUdpServer(DatagramSocket serverSocket, byte[] receiveData, byte[] sendData) throws IOException {
        DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
        serverSocket.receive(receivePacket);
        InetAddress IPAddress = receivePacket.getAddress();
        int port = receivePacket.getPort();
        DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, port);
        serverSocket.send(sendPacket);
        return receivePacket;
    }

    private String captureFullPagerMessage(DatagramPacket fullMessage) {
        return new String(fullMessage.getData());
    }

    private Timestamp setTimestamp() {
        java.util.Date date = new java.util.Date();
        return new Timestamp(date.getTime());
    }

    private void sendSMSMessages(PagerMessage pagerMessage) throws Exception {
        SmsService smsService = new SmsService();
        smsService.SendSMS(Contact.contactList, pagerMessage, false);
    }

    private void addToPagerMessageList(PagerMessage page, PagerMessage pagerMessage) {
        pagerMessage.pagerMessages.add(page);
    }

}
