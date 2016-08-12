/**
 * Created by niallgrant on 11/08/16.
 */

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.Version;
import model.Admin;
import spark.Request;
import spark.Spark;

import static spark.Spark.*;

import java.io.IOException;
import java.io.StringWriter;
import java.util.*;

public class Main {
    private static final int HTTP_BAD_REQUEST = 400;

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
        final Configuration configuration = new Configuration();
        configuration.setClassForTemplateLoading(Main.class, "/");
        staticFileLocation("/");

        Admin admin = new Admin();

        /*
        Demo Data

        for (int x = 0; x < 10; x++) {
            Admin tempAdmin = new Admin("a" + x, "a" + x, "a" + x, "a" + x, "a" + x);
            admin.adminItems.put(tempAdmin.getId(), tempAdmin);
        }
 */
        /*
        Routes
         */

        get("/", (request, response) -> {

            StringWriter writer = new StringWriter();

            try {
                Template resultTemplate = configuration.getTemplate("templates/index.ftl");
                Map<String, Object> map = new HashMap<>();
                map.put("adminList", admin.getAllAdminItems());
                resultTemplate.process(map, writer);
            } catch (Exception e) {
                halt(500);
            }

            return writer;
        });


        // Gets all available admin resources (ids)
        get("/admin", (request, response) -> {

            response.status(200);
            response.type("application/json");
            return dataToJson(admin.getAllAdminItems());

        });

        post("/admin", (request, response) -> {

            String type = request.queryParams("type");
            String reporter = request.queryParams("reporter");
            String description = request.queryParams("description");
            String status = request.queryParams("status");
            String mechanicAware = request.queryParams("mechanicAware");
            Admin tempAdmin = new Admin(type, reporter, description, status, mechanicAware);


            admin.adminItems.put(tempAdmin.getId(), tempAdmin);

            response.status(201); // 201 Created
            response.redirect("/");
            return tempAdmin.getId();
        });

        put("/admin/:id", (request, response) -> {

            String id = request.params(":id");

            Admin tempAdmin = new Admin();
            for (Admin tempAdmin1 : admin.adminItems.values()) {
                if (String.valueOf(tempAdmin1.getId()).equals(id)) {
                    tempAdmin = tempAdmin1;
                }
            }
            String newType = request.queryParams("type");
            String newReporter = request.queryParams("reporter");
            String newDescription = request.queryParams("description");
            String newStatus = request.queryParams("status");
            String newMechanicAware = request.queryParams("mechanicAware");

            if (newType != null) {
                tempAdmin.setType(newType);
            }
            if (newReporter != null) {
                tempAdmin.setReporter(newReporter);
            }
            if (newDescription != null) {
                tempAdmin.setDescription(newDescription);
            }
            if (newStatus != null) {
                tempAdmin.setStatus(newStatus);
            }
            if (newMechanicAware != null) {
                tempAdmin.setMechanicAware(newMechanicAware);
            }
            return "Admin item with id '" + id + "' updated " + newType + " " + newStatus;
        });

        delete("/admin/:id", (request, response) -> {

            String id = request.params(":id");

            for (Admin tempAdmin1 : admin.adminItems.values()) {
                if (String.valueOf(tempAdmin1.getId()).equals(id)) {
                    admin.adminItems.remove(tempAdmin1.getId());
                    response.status(200);
                    return "Admin item with id '" + id + "' deleted";
                }
            }
            response.status(404); // 404 Not found
            return "Admin item not found";
        });

        get("/adminDelete/:id", (request, response) -> {

            String id = request.params(":id");

            for (Admin tempAdmin1 : admin.adminItems.values()) {
                if (String.valueOf(tempAdmin1.getId()).equals(id)) {
                    admin.adminItems.remove(tempAdmin1.getId());
                    response.status(200);
                    return "Admin item with id '" + id + "' deleted";
                }
            }
            response.status(404); // 404 Not found
            response.redirect("/");
            return "Admin item not found";
        });

    }
}
