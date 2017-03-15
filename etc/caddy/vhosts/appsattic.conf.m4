__appsattic_APEX__ {
  proxy / localhost:__APPSATTIC_PORT__ {
    transparent
  }
  tls chilts@appsattic.com
  log stdout
  errors stderr
}

www.__appsattic_appsattic.com__ {
  redir http://__appsattic_APEX__{uri} 302
}
