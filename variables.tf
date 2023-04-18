variable parameters {
    type = map(object({
        description = string,
        type = string,
        value = string,
        tags = map(string)
       }
    ))

    validation  {
        condition = alltrue([
            for k, v in var.parameters : startswith(k, "/parameters/")
        ])
        error_message = "The key in parameters array should start with /parameters."
    }

}