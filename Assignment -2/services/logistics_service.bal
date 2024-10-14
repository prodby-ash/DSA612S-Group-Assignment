import ballerina/http;
import ballerina/log;
import ballerinax/kafka;
import ballerina/io;
import ballerina/sql;
import ballerinax/mysql;


service /logistics on new http:Listener(8081) {

    // Kafka producer to send requests
    kafka:Producer producer = checkpanic kafka:createProducer("kafka://localhost:9092");

    resource function post scheduleDelivery(http:Caller caller, http:Request req) returns error {
        // Deserialize the request payload
        DeliveryRequest deliveryRequest = check req.getJsonPayload();
        
        // Send the request to Kafka topic
        check producer->send("delivery_requests", deliveryRequest);
        
        // Send response back to client
        check caller->respond("Delivery scheduled successfully!");
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

// Kafka producer to forward delivery requests
kafka:Producer kafkaProducer = check new (kafka:DEFAULT_URL, {
    clientId: "logistics-service",
    acks: "all"
});

// MySQL client for interacting with the database
mysql:Client dbClient = check new ({
    host: "localhost",
    port: 3306,
    name: "logistics_db",
    username: "root",
    password: "password",
    options: {useSSL: false}
});

// HTTP service to handle incoming customer requests
service /logistics on new http:Listener(8081) {

    // Resource to process customer delivery requests
    resource function post requestDelivery(http:Caller caller, http:Request req) returns error? {
        json|error payload = req.getJsonPayload();
        if (payload is json) {
            string deliveryType = payload.deliveryType.toString();

            // Store the request in the database
            sql:ExecutionResult result = check dbClient->execute(
                "INSERT INTO shipments (customerId, shipmentType, pickupLocation, deliveryLocation, preferredTimeSlot) VALUES (?, ?, ?, ?, ?)",
                payload.customerName, deliveryType, payload.pickupLocation, payload.deliveryLocation
            );
            log:printInfo("Request stored in 'shipments' table.");

            // Forward the request to the appropriate Kafka topic
            kafka:ProducerRecord record = {value: payload.toString()};
            check kafkaProducer->send(deliveryType + "_delivery_topic", record);
            log:printInfo("Request forwarded to " + deliveryType + " service via Kafka.");

            // Respond to the customer
            check caller->respond("Request received for " + deliveryType + " delivery.");
        } else {
            check caller->respond("Invalid request payload.");
        }
    }
}
