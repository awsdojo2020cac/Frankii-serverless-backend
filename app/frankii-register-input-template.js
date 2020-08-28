const AWS = require("aws-sdk");
AWS.config.update({region: "ap-northeast-1"});
const dynamodb = new AWS.DynamoDB.DocumentClient;

exports.handler = async (event) => {
    const body = JSON.parse(event.body);
    await registerInputTemplate(body);
    const response = {
        statusCode: 200,
        headers: {
            'Access-Control-Allow-Origin': '*'
        }
    };
    return response;
};

function registerInputTemplate(body) {
    const params = {
        TableName: 'frankiis_questions',
        Item: {
            "category": body.category,
            "description": body.description,
            "displayText": body.displayText,
            'blocks': body.blocks,
            'template': body.template
        }
    };

    return dynamodb.put(params, (err, data) => {
        if (err) {
            console.log("Error", err);
        } else {
            console.log("Success", data);
        }
    }).promise();
}
