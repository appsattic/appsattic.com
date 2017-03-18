__APPSATTIC_APEX__ {
  proxy / localhost:__APPSATTIC_PORT__ {
    transparent
  }
  tls chilts@appsattic.com
  log stdout
  errors stderr
}

www.__APPSATTIC_APEX__ {
  redir http://__APPSATTIC_APEX__{uri} 302
}
