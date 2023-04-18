# Loop through the set of parameters and create a ressource:
resource "aws_ssm_parameter" "params" {
  for_each = var.parameters
  name  = each.key
  type  = each.value.type
  value = each.value.value
  tags  = each.value.tags
}