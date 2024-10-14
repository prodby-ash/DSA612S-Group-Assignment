import ballerina/http;
import ballerina/log;
import ballerinax/kafka;
import ballerina/io;

// Kafka consumer to receive express delivery requests
kafka:Consumer expressDeliveryConsumer = check new (kafka:DEFAULT_URL, {
    groupId: "express-delivery-service",
    topics: ["express_delivery_topic"],
    pollingIntervalInMillis: 1000
});

// HTTP service for confirmation (optional)
service /express on new http:Listener(8083) {
    resource function post handleRequest(http:Caller caller, http:Request req) returns error? {
        // Handle express delivery request here
        check caller->respond("Express delivery request processed.");
    }
}

// Start the Kafka listener for express delivery requests
listener kafka:Listener expressListener = new(expressDeliveryConsumer);

service on expressListener {

    // Resource to handle Kafka messages
    remote function onConsumerRecord(kafka:ConsumerRecord[] records) returns error? {
        foreach var record in records {
            log:printInfo("Express Delivery Request received: " + record.value);
            // Process the delivery request (details can be added here)
        }
    }
}
