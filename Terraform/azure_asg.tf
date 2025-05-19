# resource "azurerm_monitor_autoscale_setting" "autoscale" {
#   name                = "autoscale-webapp"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   target_resource_id  = azurerm_service_plan.asp.id
#   enabled             = true

#   profile {
#     name = "cpu-autoscale"

#     capacity {
#       minimum = "1"
#       maximum = "3"
#       default = "1"
#     }

#     rule {
#       metric_trigger {
#         metric_name        = "CpuPercentage"
#         metric_namespace   = "Microsoft.Web/serverfarms"
#         metric_resource_id = azurerm_service_plan.asp.id
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 70
#       }

#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = "1"
#         cooldown  = "PT5M"
#       }
#     }

#     rule {
#       metric_trigger {
#         metric_name        = "CpuPercentage"
#         metric_namespace   = "Microsoft.Web/serverfarms"
#         metric_resource_id = azurerm_service_plan.asp.id
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 30
#       }

#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = "1"
#         cooldown  = "PT5M"
#       }
#     }
#   }
# }