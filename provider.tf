variable "do_token" {
  type        = string
  description = "Digital Ocean token."
}

provider "digitalocean" {
  token = var.do_token
}