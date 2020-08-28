const AWS = require("aws-sdk");
AWS.config.update({region: "ap-northeast-1"});
const dynamodb = new AWS.DynamoDB.DocumentClient;

exports.handler = async (event, context) => {
    const body = JSON.parse(event.body);

    const templateData = await getQuestionTemplate(body.category);
    const template = templateData.Item.template;
    const questionText = generateQuestionText(template, body.input);
    const savedData = {
        TableName: 'formatted_question_text',
        Item: {
            UUID: context.awsRequestId,
            questionText: questionText,
            sender: "jonathan",
            receiver: "nakashima"
        }
    };
    await saveItemtoDynamoDB(savedData);

    const response = {
        statusCode: 200,
        body: questionText,
    };
    return response;

};

function generateQuestionText(template, input) {
    const keys = Object.keys(input);
    keys.forEach(key => {
            if (template.includes(key)) {
                let index = template.indexOf(key);
                template[index] = input[key];
            }
        }
    );
    return (template.join(''));
}

function getQuestionTemplate(category) {
    const params = {
        TableName: 'frankiis_questions',
        Key: {"category": category},
        ProjectionExpression: "template"
    };
    return dynamodb.get(params, function (err, data) {
        if (err) console.log(err, err.stack); // an error occurred
        else return data;
    }).promise();
}

function saveItemtoDynamoDB(params) {
    return dynamodb.put(params, (err, data) => {
        if (err) {
            console.error("Error when doing PutItem");
        } else {
            console.log("PutItem succeeded:");
        }
    }).promise();
}

