//setup dynamo-db stuff
const AWS = require("aws-sdk");
AWS.config.update({region: "ap-northeast-1"});
const dynamodb = new AWS.DynamoDB.DocumentClient;

exports.handler = async (event) => {
    const body = JSON.parse(event.body);
    await deleteInputTemplate(body.categories);
    const response = {
        statusCode: 200,
        headers: {
            'Access-Control-Allow-Origin': '*'
        }
    };
    return response;
};

function deleteInputTemplate(categories) {
    const params = {
        RequestItems: {
            'frankiis_questions': []
        }
    };
    categories.forEach(category => params.RequestItems.frankiis_questions.push(
        {DeleteRequest: {Key: {category: category}}}
        )
    );

    return dynamodb.batchWrite(params, (err, data) => {
        if (err) {
            console.log(err); // an error occurred
        }
    }).promise();
}
