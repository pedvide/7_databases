/***
 * Excerpted from "Seven Databases in Seven Weeks",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/pwrdata for more book information.
***/
var AWS = require('aws-sdk');
var DynamoDB = new AWS.DynamoDB({
  apiVersion: '2012-08-10',
  region: 'us-east-1',
});

exports.kinesisHandler = function(event, context, callback) {
  // We only need to handle one record at a time
  var kinesisRecord = event.Records[0];

  // The data payload is base 64 encoded and needs to be decoded to a string
  var data   =
    Buffer.from(kinesisRecord.kinesis.data, 'base64').toString('ascii');
  // Create a JSON object out of that string
  var obj    = JSON.parse(data);
  var sensorId    = obj.sensor_id,
      currentTime = obj.current_time,
      temperature = obj.temperature;

  // Define the item to write to DynamoDB
  var item = {
    TableName: "SensorData",
    Item: {
      SensorId: {
        S: sensorId
      },
      CurrentTime: {
        // Remember that all numbers need to be input as strings
        N: currentTime.toString()
      },
      Temperature: {
        N: temperature.toString()
      }
    }
  };

  // Perform a put operation, logging both successes and failures
  DynamoDB.putItem(item, function(err, data) {
    if (err) {
      console.log(err, err.stack);
      callback(err.stack);
    } else {
      console.log(data);
      callback(null, data);
    }
  });
}
