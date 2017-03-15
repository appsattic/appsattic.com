[program:appsattic]
directory = /home/chilts/src/appsattic-appsattic.com
command = /home/chilts/src/appsattic-appsattic.com/bin/appsattic
user = chilts
autostart = true
autorestart = true
stdout_logfile = /var/log/chilts/appsattic-stdout.log
stderr_logfile = /var/log/chilts/appsattic-stderr.log
environment =
    APPSATTIC_PORT="__APPSATTIC_PORT__",
    APPSATTIC_APEX="__APPSATTIC_APEX__",
    APPSATTIC_BASE_URL="__APPSATTIC_BASE_URL__"
