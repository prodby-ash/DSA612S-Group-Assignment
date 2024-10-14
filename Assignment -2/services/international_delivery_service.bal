import ballerina/http;
import ballerina/log;
import ballerinax/kafka;
import ballerina/io;

// Kafka consumer to receive international delivery requests
kafka:Consumer internationalDeliveryConsumer = check new (kafka:DEFAULT_URL, {
    groupId: "international-delivery-service",
    topics: ["international_delivery_topic"],
    pollingIntervalInMillis: 1000
});

// HTTP service for confirmation (optional)
service /international on new http:Listener(8084) {
    resource function post handleRequest(http:Caller caller, http:Request req) returns error? {
        // Handle international delivery request here
        check caller->respond("International delivery request processed.");
    }
}

// Start the Kafka listener for international delivery requests
listener kafka:Listener internationalListener = new(internationalDeliveryConsumer);

service on internationalListener {

    // Resource to handle Kafka messages
    remote function onConsumerRecord(kafka:ConsumerRecord[] records) returns error? {
        foreach var record in records {
            log:printInfo("International Delivery Request received: " + record.value);
            // Process the delivery request (details can be added here)
        }
    }
}
