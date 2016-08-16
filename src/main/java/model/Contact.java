package model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by niallgrant on 16/08/16.
 */
public class Contact {
    private String name;
    private String phoneNumber;
    public static List<Contact> contactList = new ArrayList<>();


    public Contact(String name, String phoneNumber) {
        this.name = name;
        this.phoneNumber = phoneNumber;

    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

}
