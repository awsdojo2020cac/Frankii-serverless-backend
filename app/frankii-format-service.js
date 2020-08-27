//setup dynamo-db stuff
const AWS = require("aws-sdk");
AWS.config.update({region: "ap-northeast-1"});
const dynamodb = new AWS.DynamoDB.DocumentClient;

//helper functions
function generateQuestionText(input) {
    let questionTemplate = ["現在以下のタスクに取り組んでいます。\n\`\`\`", "task", "\`\`\` \n*", "genre", "* に関して、以下の事象が発生しました:dizzy_face:：\n\`\`\`", "errorContent", "\`\`\` \n", "エラーメッセージはこれです:sob:：\n\`\`\`", "errorMsg", "\`\`\`"];

    getQuestionTemplate("errors").then(res => console.log(res, "hi")); //todo

    const keys = Object.keys(input);
    keys.forEach(key => {
            if (questionTemplate.includes(key)) {
                let index = questionTemplate.indexOf(key);
                questionTemplate[index] = input[key];
            }
        }
    );
    return (questionTemplate.join(''));
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

function getQuestionTemplate(category) {
    const params = {
        TableName: 'question_templates',
        Key: {"category": category}
    };
    return dynamodb.get(params, function (err, data) {
        if (err) console.log(err, err.stack); // an error occurred
        else return data;
    }).promise();
}

exports.handler = async (event, context) => {
    const questionText = generateQuestionText(event);
    const params = {
        TableName: 'formatted_question_text',
        Item: {
            UUID: context.awsRequestId,
            questionText: questionText,
            sender: "jonathan",
            receiver: "nakashima"
        }
    };

    await saveItemtoDynamoDB(params);

    const response = {
        statusCode: 200,
        body: questionText,
    };
    return response;

};