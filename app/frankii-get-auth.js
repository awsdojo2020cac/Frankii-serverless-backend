const https = require('https');
const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB();

const addToken = async (userId, userToken) => {
    const params = {
        Item: {
            'slack_uid': {S: userId},
            'user_token': {S: userToken}
        },
        ReturnValues: 'ALL_OLD',
        TableName: process.env.TOKEN_TABLE
        };
    const result = await dynamodb.putItem(params).promise();
    return result;
};

exports.handler = async (event) => {
    //define request parameters
    const clientId = process.env.SLACK_CLIENT_ID;
    const clientSecret = process.env.SLACK_CLIENT_SECRET;
    const tmpCode = event["queryStringParameters"]["code"];
    const oauthURL = 'https://slack.com/api/oauth.v2.access?' +
        'client_id=' + clientId + '&' +
        'client_secret=' + clientSecret + '&' +
        'code=' + tmpCode;

    console.log(oauthURL);

    const response = await new Promise((resolve, reject) => {
        const req = https.get(oauthURL, function (res) {
            res.on('data', dd => {
                resolve(JSON.parse(dd));
            });
        });
        req.on('error', (e) => {
            console.log('req on error');
            reject({
                statusCode: 500,
                body: 'Something went wrong!'
            });
        });
    });

    const usrId = response['authed_user']['id'];
    const usrToken = response['authed_user']['access_token'];

    try{
        const addUser = await addToken(usrId, usrToken);
        console.log(addUser);
        return {
            statusCode: 200,
            body : 'authentication successful'

        };
    }catch (err){
        console.log(err);
        return {
            statusCode: 500,
            body: 'Something went wrong with the Service'
        };
    }
};
