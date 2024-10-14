import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerinax/kafka;

// Kafka consumer to receive standard delivery requests
kafka:Consumer standardDeliveryConsumer = check new (kafka:DEFAULT_URL, {
    groupId: "standard-delivery-service",
    topics: ["standard_delivery_topic"]
});
// HTTP service for confirmation (optional, could be removed)
service /standard on new http:Listener(8082) {
    resource function post handleRequest(http:Caller caller, http:Request req) returns error? {
        // Handle standard delivery request here
        check caller->respond("Standard delivery request processed.");
    }
}

// Start the Kafka listener for standard delivery requests
listener kafka:Listener standardListener = new("standardDeliveryConsumer");

service on standardListener {

    // Resource to handle Kafka messages
    remote function onConsumerRecord(kafka:ConsumerRecord[] records) returns error? {

        foreach var record in records {
            log:printInfo("Standard Delivery Request received: " + record.value);
        }
    }
}