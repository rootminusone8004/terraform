data "aws_ssm_parameter" "windows_server_2025" {
  name = "/aws/service/ami-windows-latest/Windows_Server-2025-English-Full-Base"
}

data "http" "my_ip" {
  url = "https://api.ipify.org"
}
