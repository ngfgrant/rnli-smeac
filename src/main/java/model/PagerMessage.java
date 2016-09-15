package model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by niallgrant on 13/08/16.
 */
public class PagerMessage {

    private Timestamp timestamp;
    private String fullMessage;
    private String alpha;
    private String function;
    private String address;
    private String pagerFormatEncoding;
    public List<PagerMessage> pagerMessages = new ArrayList<PagerMessage>();
    private static List<String> alphaCleaner = new ArrayList<String>();

    public PagerMessage(Timestamp timestamp, String fullMessage) {
        this.fullMessage = fullMessage;
        this.timestamp = timestamp;
        this.pagerFormatEncoding = getFirstWord(fullMessage);
        this.address = splitMessage(fullMessage,"Address: ","Function:");
        this.function = splitMessage(fullMessage, "Function: ", "Alpha:");
        this.alpha = cleanAlphaText(fullMessage);
    }

    public PagerMessage() {
    }

    private String getFirstWord(String text) {
        if (text.indexOf(' ') > -1) { // Check if there is more than one word.
            return text.substring(0, text.indexOf(":")); // Extract first word.
        } else {
            return text; // Text is the first word itself.
        }
    }

    private String splitMessage(String message, String splitTextFrom, String splitTextTo) {
        String[] split = message.split(splitTextFrom);
        String pagerMessageString = split[1];
        String[] split2 = pagerMessageString.split(splitTextTo);
        String pagerMessageString2 = split2[0];
        return pagerMessageString2.toUpperCase();
    }
    public static void initialiseForbiddenAlphaTextList() {
        alphaCleaner.add("<NUL>");
        alphaCleaner.add("<ENQ>");
        alphaCleaner.add("<");
        alphaCleaner.add(">");
    }

    private String cleanAlphaText(String fullMessage){
        String tempAlpha = splitMessage(fullMessage, "Alpha:   ", "POCSAG");
        for (String forbiddenAlphaText : alphaCleaner){
            if(tempAlpha.contains(forbiddenAlphaText)){
                tempAlpha = tempAlpha.replace(forbiddenAlphaText,"");
            }
        }
        return tempAlpha;
    }


    public String getFullMessage() {
        return fullMessage;
    }

    public void setFullMessage(String fullMessage) {
        this.fullMessage = fullMessage;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public String getTimestampFormatted() {
        return new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(timestamp);
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public String getAlpha() {
        return alpha;
    }

    public void setAlpha(String alpha) {
        this.alpha = alpha;
    }

    public String getPagerFormatEncoding() {
        return pagerFormatEncoding;
    }

    public void setPagerFormatEncoding(String pagerFormatEncoding) {
        this.pagerFormatEncoding = pagerFormatEncoding;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getFunction() {
        return function;
    }

    public void setFunction(String function) {
        this.function = function;
    }
}
