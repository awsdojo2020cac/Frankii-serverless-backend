//setup dynamo-db stuff
const AWS = require("aws-sdk");
AWS.config.update({region: "ap-northeast-1"});
const dynamodb = new AWS.DynamoDB.DocumentClient;

exports.handler = async (event) => {
    let data = await deleteInputTemplate(event.pathParameters.category);
    const response = {
        statusCode: 200,
        body: JSON.stringify(data["Item"]),
        headers: {
            'Access-Control-Allow-Origin': '*'
        }
    };
    return response;
};

function deleteInputTemplate(category) {
    const params = {
        TableName: 'frankiis_questions',
        Key: {"category": category}
    };
    return dynamodb.delete(params, (err, data) => {
        if (err) {
            console.log(err); // an error occurred
        }
    }).promise();
}
