# # aws - vpn gateway
# resource "aws_vpn_gateway" "vpn_gateway" {
#   vpc_id          = aws_vpc.vpc.id
#   amazon_side_asn = 64512

#   tags = {
#     Name = "vpn-to-azure"
#   }
# }

# # aws - customer gateway
# resource "aws_customer_gateway" "azure_cgw" {
#   bgp_asn    = 65000
#   ip_address = azurerm_public_ip.vpn_gateway_pip.ip_address #"4.230.31.128"
#   type       = "ipsec.1"

#   tags = {
#     Name = "azure-customer-gateway"
#   }
# }

# # vpn connection
# resource "aws_vpn_connection" "vpn_connection" {
#   vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
#   customer_gateway_id = aws_customer_gateway.azure_cgw.id
#   type                = "ipsec.1"

#   static_routes_only = true

#   tunnel1_preshared_key = "MyToToRoSecretSharedKey123"
#   tunnel1_inside_cidr   = "169.254.21.0/30"

#   tunnel2_preshared_key = "MyToToRoSecretSharedKey123"
#   tunnel2_inside_cidr   = "169.254.22.0/30"

#   tags = {
#     Name = "vpn-aws-to-azure"
#   }
# }

# resource "aws_vpn_gateway_attachment" "this" {
#      vpc_id = aws_vpc.vpc.id
#      vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
# }

# resource "aws_vpn_gateway_route_propagation" "this" {
#      vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
#      route_table_id = aws_route_table.routetable["back1"].id
# }

# resource "aws_vpn_gateway_route_propagation" "this2" {
#      vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
#      route_table_id = aws_route_table.routetable["back2"].id
# }


# # vpn routes
# resource "aws_vpn_connection_route" "to_azure_vnet" {
#   vpn_connection_id      = aws_vpn_connection.vpn_connection.id
#   destination_cidr_block = "10.2.0.0/16" # Azure VNet의 CIDR (임시)
# }
