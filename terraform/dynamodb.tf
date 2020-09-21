resource "aws_dynamodb_table" "frankii_main_dynamodb" {
  name           = var.frankii_main_dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "category"

  attribute {
    name = "category"
    type = "S"
  }
}

resource "aws_dynamodb_table" "formatted_question_text" {
  name           = "formatted_question_text"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "UUID"

  attribute {
    name = "UUID"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "init_data" {
  table_name = aws_dynamodb_table.frankii_main_dynamodb.name
  hash_key   = aws_dynamodb_table.frankii_main_dynamodb.hash_key

  item = <<ITEM
{
  "category": {"S": "web-mtg"},
  "description": {"S": "WEB会議"},
  "displayText": {"S": "WEB会議"},
  "blocks": {"L": [{"M" : {"blockId" : {"N" : "0"}, "key" : {"S" : "participants"}, "label" : {"S" : "参加者"}, "multiline" : {"BOOL" : false}, "type" : {"S" : "String"}}},    {"M" : {"blockId" : {"N" : "1"}, "key" : {"S" : "time"}, "label" : {"S" : "会議時間"}, "type" : {"S" : "String"}}},    {"M" : {"blockId" : {"N" : "2"}, "key" : {"S" : "duration"}, "label" : {"S" : "会議所要時間(目安)"}, "type" : {"S" : "String"}}},    {"M" : {"blockId" : {"N" : "3"}, "key" : {"S" : "about"}, "label" : {"S" : "会議内容"}, "type" : {"S" : "String"},"multiline" : {"BOOL" : true}}},  {"M" : {"blockId" : {"N" : "4"}, "key" : {"S" : "mtg-link"}, "label" : {"S" : "会議URLリンク"}, "type" : {"S" : "String"}}}]},
  "template": {"L":[{"S" : "・参加者(@指定): "},    {"S" : "participants"},    {"S" : "\n・会議時間: "},    {"S" : "time"},    {"S" : "\n・会議所要時間(目安)："},    {"S" : "duration"},    {"S" : "\n・会議内容:　"},    {"S" : "about"},    {"S" : "\n・URLリンク："},    {"S" : "mtg-link"}]}
}
ITEM
}

//When larger amounts of intial data are required, use this https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchWriteItem.html
//write a json file and use the aws cli to batch-write-item the json into the datatable.

