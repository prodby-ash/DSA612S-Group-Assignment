import ballerina/http;
import ballerina/io;

public function main() {
    http:Client logisticsClient = check new("http://localhost:8081/logistics");

    DeliveryRequest request = {
        shipmentType: "standard",
        pickupLocation: "123 Main St",
        deliveryLocation: "456 Elm St",
        preferredTime: "10 AM",
        customerName: "John Doe",
        contactNumber: "123-456-7890"
    };

    var response = logisticsClient->post("/scheduleDelivery", request);
    
    if (response is http:Response) {
        io:println("Response: ", response.getJsonPayload());
    } else {
        io:println("Error: ", response);
    }
}

type DeliveryRequest record {
    string shipmentType;
    string pickupLocation;
    string deliveryLocation;
    string preferredTime;
    string customerName;
    string contactNumber;
};
