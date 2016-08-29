package pager;

import model.Contact;
import model.PagerMessage;
import services.SmsService;

import java.lang.reflect.Array;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.sql.Timestamp;

/**
 * Created by niallgrant on 13/08/16.
 */
public class UdpServer {

    public static void main(String args[]) throws Exception {
        DatagramSocket serverSocket = new DatagramSocket(9876);
        byte[] receiveData = new byte[1024];
        byte[] sendData = new byte[1024];
        while (true) {
            DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
            serverSocket.receive(receivePacket);
            String sentence = new String(receivePacket.getData());
            System.out.println(sentence);
            try {
                String[] split = sentence.split("Alpha:");
                String pagerMessage = split[1];
                String pagerPreample = split[0];
                String[] split2 = pagerMessage.split("POCSAG512");
                String pagerMessage2 = split2[0];
                System.out.println("RECEIVED: " + setTimestamp() + "  " + pagerMessage2);


                PagerMessage pagerMessage1 = new PagerMessage(setTimestamp(), pagerMessage2);
                InetAddress IPAddress = receivePacket.getAddress();

                int port = receivePacket.getPort();
                String capitalizedSentence = sentence.toUpperCase();
                sendData = capitalizedSentence.getBytes();
                DatagramPacket sendPacket =
                        new DatagramPacket(sendData, sendData.length, IPAddress, port);
                serverSocket.send(sendPacket);
            } catch (ArrayIndexOutOfBoundsException e) {
                e.printStackTrace();
            }

        }
    }

    public void init(PagerMessage pagerMessage) throws Exception {
        DatagramSocket serverSocket = new DatagramSocket(9876);
        byte[] receiveData = new byte[1024];
        byte[] sendData = new byte[1024];
        while (true) {

            try {
                DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
                serverSocket.receive(receivePacket);
                String sentence = new String(receivePacket.getData());
                String[] split = sentence.split("Alpha:");
                String pagerMessageString = split[1];
                String[] split2 = pagerMessageString.split("POCSAG");
                String pagerMessageString2 = split2[0];
                Timestamp timestamp = setTimestamp();

                System.out.println(sentence);
                System.out.println("RECEIVED: " + timestamp + " " + sentence + "\n");
                System.out.println("RECEIVED: " + timestamp + " " + pagerMessageString2 + "\n");

                PagerMessage page = new PagerMessage(timestamp, pagerMessageString2);
                pagerMessage.pagerMessages.add(page);

                SmsService smsService = new SmsService();
                smsService.SendSMS(Contact.contactList, page);

                for (PagerMessage pm : pagerMessage.pagerMessages) {
                    System.out.println("Added to list: " + pm.getTimestamp() + " " + pm.getMessage());
                }

                InetAddress IPAddress = receivePacket.getAddress();

                int port = receivePacket.getPort();
                String capitalizedSentence = sentence.toUpperCase();
                sendData = capitalizedSentence.getBytes();
                DatagramPacket sendPacket =
                        new DatagramPacket(sendData, sendData.length, IPAddress, port);
                serverSocket.send(sendPacket);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static Timestamp setTimestamp() {
        java.util.Date date = new java.util.Date();
        return new Timestamp(date.getTime());
    }
}
