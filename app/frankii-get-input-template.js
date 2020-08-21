//setup dynamo-db stuff
const AWS = require("aws-sdk");
AWS.config.update({region: "ap-northeast-1"});
const dynamodb = new AWS.DynamoDB.DocumentClient;

exports.handler = async (event) => {
    let data = await getInputTemplate(event.pathParameters.category)
    const response = {
        statusCode: 200,
        body: JSON.stringify(data["Item"])
    };
    return response;
};

function getInputTemplate(category) {
    const params = {
        TableName: 'frankiis_questions',
        Key: {"category": category}
    };
    return dynamodb.get(params, (err, data) => {
        if (err) {
            console.log(err); // an error occurred
        }
    }).promise();
}
