variable "app_version" {
  type    = string
  default = "1.0.0"
}

variable "deploy_stage" {
  type    = string
  default = "dev"
}

variable "frankii_get_question_categories_function_name" {
  type        = string
  description = "Function name of the node.js function that gets all Frankii question categories"
  default     = "frankii-get-question-categories"
}

variable "frankii_get_input_template_function_name" {
  type    = string
  default = "frankii-get-input-template"
}
