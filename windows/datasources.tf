data "aws_ssm_parameter" "windows_server_2022" {
  name = "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-Base"
}

data "http" "my_ip" {
  url = "https://api.ipify.org"
}
