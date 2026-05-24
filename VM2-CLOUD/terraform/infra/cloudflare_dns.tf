data "cloudflare_zero_trust_tunnel_cloudflared" "muestra_tunnel" {
  account_id = var.cloudflare_account_id
  name       = "muestra_tunnel"
}

resource "cloudflare_record" "master" {
  zone_id = var.cloudflare_zone_id
  name    = "master"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.muestra_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  allow_overwrite = true
}

resource "cloudflare_record" "www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  content = "${data.cloudflare_zero_trust_tunnel_cloudflared.muestra_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  allow_overwrite = true
}

resource "cloudflare_record" "root" {
  zone_id         = var.cloudflare_zone_id
  name            = "@"
  content         = "${data.cloudflare_zero_trust_tunnel_cloudflared.muestra_tunnel.id}.cfargotunnel.com"
  type            = "CNAME"
  proxied         = true
  allow_overwrite = true
}