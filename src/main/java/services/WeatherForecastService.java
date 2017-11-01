package services;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

/**
 * Created by niallgrant on 13/05/17.
 */
public class WeatherForecastService {


    public String getInshoreWeather() throws Exception {
        URL website = new URL("https://www.metoffice.gov.uk/public/data/CoreProductCache/InshoreWatersForecast/Latest?concise");
        URLConnection connection = website.openConnection();
        BufferedReader in = new BufferedReader(
                new InputStreamReader(
                        connection.getInputStream()));

        StringBuilder response = new StringBuilder();
        String inputLine;

        while ((inputLine = in.readLine()) != null)
            response.append(inputLine);

        in.close();

        return response.toString();
    }

    public Document getMetOfficeInshoreForecastXML() throws Exception {
        URL url = new URL("https://www.metoffice.gov.uk/public/data/CoreProductCache/InshoreWatersForecast/Latest?concise");
        URLConnection connection = url.openConnection();
        Document doc = parseXML(connection.getInputStream());
        return doc;
    }

    private Document parseXML(InputStream stream) throws Exception {
        DocumentBuilderFactory objDocumentBuilderFactory = null;
        DocumentBuilder objDocumentBuilder = null;
        Document doc = null;
        objDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
        objDocumentBuilder = objDocumentBuilderFactory.newDocumentBuilder();
        doc = objDocumentBuilder.parse(stream);
        return doc;
    }

}
