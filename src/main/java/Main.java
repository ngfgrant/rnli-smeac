/**
 * Created by niallgrant on 11/08/16.
 */

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import freemarker.template.Configuration;
import freemarker.template.Template;
import model.AdministrationItem;
import model.Contact;
import model.PagerMessage;
import pager.UdpServer;

import static spark.Spark.*;

import java.io.IOException;
import java.io.StringWriter;
import java.util.*;

public class Main {
    /*
    JSON setup
     */
    public static String dataToJson(Object data) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.enable(SerializationFeature.INDENT_OUTPUT);
            StringWriter sw = new StringWriter();
            mapper.writeValue(sw, data);
            return sw.toString();
        } catch (IOException e) {
            throw new RuntimeException("IOException from a StringWriter?");
        }
    }

    public static void main(String args[]) {
        /*
        Config
         */
        Contact contact = new Contact("Niall Grant", "447969848782");
        Contact.contactList.add(contact);
        staticFileLocation("/templates");
        final Configuration configuration = new Configuration();
        configuration.setClassForTemplateLoading(Main.class, "/");
        port(9090);
        PagerMessage.initialiseForbiddenAlphaTextList();

        AdministrationItem administrationItem = new AdministrationItem();

        PagerMessage pagerMessage = new PagerMessage();

        /*
        Routes
         */

        get("/", (request, response) -> {

            StringWriter writer = new StringWriter();

            try {
                Template resultTemplate = configuration.getTemplate("templates/index.ftl");
                Map<String, Object> map = new HashMap<>();
                map.put("adminList", administrationItem.getAllAdminItems());

                map.put("pagerMessage", pagerMessage.pagerMessages);

                resultTemplate.process(map, writer);
            } catch (Exception e) {
                halt(500);
            }
            return writer;
        });

        get("/contact", (request, response) -> {
            StringWriter writer = new StringWriter();
            try {
                Template resultTemplate = configuration.getTemplate("templates/contact.ftl");

                resultTemplate.process(null, writer);
            } catch (Exception e) {
                halt(500);
            }
            return writer;
        });


        // Gets all available admin resources (ids)
        get("/admin", (request, response) -> {
            response.status(200);
            response.type("application/json");
            return dataToJson(administrationItem.getAllAdminItems());
        });

        post("/admin", (request, response) -> {
            String type = request.queryParams("type");
            String reporter = request.queryParams("reporter");
            String description = request.queryParams("description");
            String status = request.queryParams("status");
            String mechanicAware = request.queryParams("mechanicAware");
            AdministrationItem tempAdministrationItem = new AdministrationItem(type, reporter, description, status, mechanicAware);
            administrationItem.adminItems.put(tempAdministrationItem.getId(), tempAdministrationItem);
            response.status(201); // 201 Created
            response.redirect("/");
            return tempAdministrationItem.getId();
        });

        post("/contact", (request, response) -> {
            String name = request.queryParams("name");
            String number = request.queryParams("number");
            Contact newContact = new Contact(name, number);
            Contact.contactList.add(newContact);
            for (Contact tempContact : Contact.contactList) {
                System.out.println(tempContact.getName());
                System.out.println(tempContact.getPhoneNumber() + "\n");
            }
            response.status(201); // 201 Created
            response.redirect("/");
            return newContact.getName();
        });

        put("/admin/:id", (request, response) -> {
            String id = request.params(":id");
            AdministrationItem tempAdministrationItem = new AdministrationItem();
            for (AdministrationItem tempAdministrationItem1 : administrationItem.adminItems.values()) {
                if (String.valueOf(tempAdministrationItem1.getId()).equals(id)) {
                    tempAdministrationItem = tempAdministrationItem1;
                }
            }

            String newType = request.queryParams("type");
            String newReporter = request.queryParams("reporter");
            String newDescription = request.queryParams("description");
            String newStatus = request.queryParams("status");
            String newMechanicAware = request.queryParams("mechanicAware");

            if (newType != null) {
                tempAdministrationItem.setType(newType);
            }
            if (newReporter != null) {
                tempAdministrationItem.setReporter(newReporter);
            }
            if (newDescription != null) {
                tempAdministrationItem.setDescription(newDescription);
            }
            if (newStatus != null) {
                tempAdministrationItem.setStatus(newStatus);
            }
            if (newMechanicAware != null) {
                tempAdministrationItem.setMechanicAware(newMechanicAware);
            }
            return "Admin item with id '" + id + "' updated " + newType + " " + newStatus;
        });

        delete("/admin/:id", (request, response) -> {
            String id = request.params(":id");
            for (AdministrationItem tempAdministrationItem1 : administrationItem.adminItems.values()) {
                if (String.valueOf(tempAdministrationItem1.getId()).equals(id)) {
                    administrationItem.adminItems.remove(tempAdministrationItem1.getId());
                    response.status(200);
                    return "Admin item with id '" + id + "' deleted";
                }
            }
            response.status(404); // 404 Not found
            return "Admin item not found";
        });

        get("/adminDelete/:id", (request, response) -> {

            String id = request.params(":id");

            for (AdministrationItem tempAdministrationItem1 : administrationItem.adminItems.values()) {
                if (String.valueOf(tempAdministrationItem1.getId()).equals(id)) {
                    administrationItem.adminItems.remove(tempAdministrationItem1.getId());
                    response.status(200);
                    return "Admin item with id '" + id + "' deleted";
                }
            }
            response.status(404); // 404 Not found
            response.redirect("/");
            return "Admin item not found";
        });

        get("/pagerMessages", (request, response) -> {
            response.status(200);
            response.type("application/json");
            return dataToJson(pagerMessage.pagerMessages.toArray());
        });

        get("/clearPagerMessages", (request, response) -> {
            pagerMessage.pagerMessages.clear();
            response.status(200);
            response.redirect("/");
            return "Pager Messages Cleared";
        });

        get("/refreshMessages", (request, response) -> {
            StringBuilder htmlBuilder = new StringBuilder();
            htmlBuilder.append("<h2> <span class='blink_me red'>");
            htmlBuilder.append(pagerMessage.pagerMessages.get(pagerMessage.pagerMessages.size() - 1).getAlpha())
                    .append("</span> - <span class='red'>")
                    .append(pagerMessage.pagerMessages.get(pagerMessage.pagerMessages.size() - 1).getTimestampFormatted())
                    .append(" (Local) </span></h2>");

            return htmlBuilder.toString();
        });

        UdpServer udpServer = new UdpServer();
        try {
            udpServer.init(pagerMessage);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
