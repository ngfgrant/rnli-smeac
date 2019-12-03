package pager;

import model.PagerMessage;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by niallgrant on 13/08/16.
 */
public class UdpServer {
    private List<String> approvedMessages = new ArrayList<String>();

    public void init(PagerMessage pagerMessage) throws Exception {
        initialiseApprovedMessageList();
        DatagramSocket serverSocket = new DatagramSocket(9876);
        byte[] receiveData = new byte[1024];
        byte[] sendData = new byte[1024];
        while (true) {
            try {
                DatagramPacket receivePacket = initialUdpServer(serverSocket, receiveData, sendData);
                String fullPagerMessage = captureFullPagerMessage(receivePacket);
                PagerMessage page = new PagerMessage(setTimestamp(), fullPagerMessage);
                if (pageIsAnApprovedMessage(page)) {
                    addToPagerMessageList(page, pagerMessage);
                    sendData = fullPagerMessage.getBytes();
                    System.out.println(fullPagerMessage);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void initialiseApprovedMessageList() {
        approvedMessages.add("LAUNCH ILB");
        approvedMessages.add("CANCEL LAUNCH");
        approvedMessages.add("SYSTEM TEST");
        approvedMessages.add("IMMEDIATE READINESS");
        approvedMessages.add("CREW ASSEMBLE");
    }

    private boolean pageIsAnApprovedMessage(PagerMessage page) {
        for (String pagerMessage : approvedMessages) {
            if (page.getAlpha().contains(pagerMessage)) {
                return true;
            }
        }
        return false;
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

    private void addToPagerMessageList(PagerMessage page, PagerMessage pagerMessage) {
        pagerMessage.pagerMessages.add(page);
    }

}
