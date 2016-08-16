package model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by niallgrant on 13/08/16.
 */
public class PagerMessage {

    public Timestamp timestamp;
    public String message;
    public List<PagerMessage> pagerMessages = new ArrayList<PagerMessage>();

    public PagerMessage(Timestamp timestamp, String message) {
        this.timestamp = timestamp;
        this.message = message;
    }
    public PagerMessage() {
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

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

}
