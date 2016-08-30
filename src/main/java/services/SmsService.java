package services;

import com.nexmo.messaging.sdk.NexmoSmsClient;
import com.nexmo.messaging.sdk.SmsSubmissionResult;
import com.nexmo.messaging.sdk.messages.TextMessage;
import model.Contact;
import model.PagerMessage;

import java.util.List;

public class SmsService {

    public static final String API_KEY = "7a6f906f";
    public static final String API_SECRET = "d6a32cce";
    public static final String SMS_FROM = "Pager";

    public void SendSMS(List<Contact> contactList, PagerMessage pagerMessage, boolean isDebugMode) throws Exception {
        for (Contact contact : contactList) {
            SmsSubmissionResult[] results = sendSMSMessageToContact(contact.getPhoneNumber(), pagerMessage);
            if (isDebugMode) {
                debugSMSMode(results);
            }
        }
    }

    private static NexmoSmsClient SMSClient() {
        NexmoSmsClient client;
        try {
            client = new NexmoSmsClient(API_KEY, API_SECRET);
            return client;
        } catch (Exception e) {
            System.err.println("Failed to instantiate a Nexmo Client");
            e.printStackTrace();
            throw new RuntimeException("Failed to instantiate a Nexmo Client");
        }
    }

    private SmsSubmissionResult[] sendSMSMessageToContact(String contactNumber, PagerMessage pagerMessage) throws Exception {
        TextMessage textMessage = new TextMessage(SMS_FROM, contactNumber, pagerMessage.getAlpha());
        return SMSClient().submitMessage(textMessage);
    }

    private void debugSMSMode(SmsSubmissionResult[] results) {
        try {
            printDiagnositcMessages(results);
        } catch (Exception e) {
            System.err.println("Failed to communicate with the Nexmo Client");
            e.printStackTrace();
            throw new RuntimeException("Failed to communicate with the Nexmo Client");
        }
    }

    private void printDiagnositcMessages(SmsSubmissionResult[] results) {
        // Evaluate the results of the submission attempt ...
        System.out.println("... Message submitted in [ " + results.length + " ] parts");
        for (int i = 0; i < results.length; i++) {
            System.out.println("--------- part [ " + (i + 1) + " ] ------------");
            System.out.println("Status [ " + results[i].getStatus() + " ] ...");
            if (results[i].getStatus() == SmsSubmissionResult.STATUS_OK)
                System.out.println("SUCCESS");
            else if (results[i].getTemporaryError())
                System.out.println("TEMPORARY FAILURE - PLEASE RETRY");
            else
                System.out.println("SUBMISSION FAILED!");
            System.out.println("Message-Id [ " + results[i].getMessageId() + " ] ...");
            System.out.println("Error-Text [ " + results[i].getErrorText() + " ] ...");

            if (results[i].getMessagePrice() != null)
                System.out.println("Message-Price [ " + results[i].getMessagePrice() + " ] ...");
            if (results[i].getRemainingBalance() != null)
                System.out.println("Remaining-Balance [ " + results[i].getRemainingBalance() + " ] ...");
        }
    }

}

