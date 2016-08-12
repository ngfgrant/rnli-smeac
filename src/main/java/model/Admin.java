package model;

import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Created by niallgrant on 11/08/16.
 */
public class Admin {

    public UUID id;
    public String timestamp;
    public String type;
    public String reporter;
    public String description;
    public String status;
    public String mechanicAware;
    public Map<UUID, Admin> adminItems = new HashMap<UUID, Admin>();

    public Admin(String type, String reporter, String description, String status, String mechanicAware) {
        this.id = UUID.randomUUID();
        this.timestamp = setTimestamp();
        this.type = type;
        this.reporter = reporter;
        this.description = description;
        this.status = status;
        this.mechanicAware = mechanicAware;
    }

    public Admin (){

    }
    public UUID createAdminItem(String type, String reporter, String description, String status, String mechanicAware) {
        Admin adminItem = new Admin(type, reporter, description, status, mechanicAware);
        adminItems.put(adminItem.getId(), adminItem);
        return id;
    }

    public List<Admin> getAllAdminItems() {
        return adminItems.keySet().stream().sorted().map(adminItems::get).collect(Collectors.toList());
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getReporter() {
        return reporter;
    }

    public void setReporter(String reporter) {
        this.reporter = reporter;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMechanicAware() {
        return mechanicAware;
    }

    public void setMechanicAware(String mechanicAware) {
        this.mechanicAware = mechanicAware;
    }

    private String setTimestamp(){
       java.util.Date date= new java.util.Date();
       return new Timestamp(date.getTime()).toString();
    }

    public String getTimestamp() {
        return timestamp;
    }
}

