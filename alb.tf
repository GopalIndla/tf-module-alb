# Provisions ALB
resource "aws_lb" "alb" {
  name               = var.ALB_NAME
  internal           = var.INTERNAL
  load_balancer_type = "application"
  security_groups    = var.INTERNAL ? aws_security_group.allow_private.*.id  : aws_security_group.allow_public.*.id 
  subnets            = var.INTERNAL ? data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS : data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNET_IDS

  enable_deletion_protection = false 

  tags = {
    Environment = var.ALB_NAME
  }
}


# Public-Module  --->  Public ALB  + Public SG  + Public Subnets 
# Private-Module --->  Private ALB + Private SG + Private Subnets 
# listeners should be coming from the application and we will place listeners under the respective component.
# Bring Up the components 
    # > If the component is frontend : create them on public subnets and that should be load-balanced by public alb 
    # > If the component is backend  : create them on private subnets and that should be load-balanced by private alb 
    
# >>> VPC ---> DB's ---> ALB ---> Components 