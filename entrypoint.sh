#!/bin/sh

# Core config
sed -i -e "s/^;daemonize=true/daemonize=false/" "$HARAKA_ROOT/config/smtp.ini"
sed -i -e "s/^#process_title/process_title/" "$HARAKA_ROOT/config/plugins"
sed -i -e "s/^#rcpt_to\.in_host_list/rcpt_to.in_host_list/" "$HARAKA_ROOT/config/plugins"
sed -i -e "s/^#relay/relay\nrelay_acl/" "$HARAKA_ROOT/config/plugins"
sed -i -e "s/^#data\.headers/data.headers/" "$HARAKA_ROOT/config/plugins"
sed -i -e "s/^#queue\/smtp_forward/queue\/smtp_forward/" "$HARAKA_ROOT/config/plugins"
sed -i -e "s/^#max_unrecognized_commands/max_unrecognized_commands/" "$HARAKA_ROOT/config/plugins"

# Relay config
cat <<EOT > "$HARAKA_ROOT/config/relay_acl_allow"
127.0.0.1
::1
EOT
cat <<EOT > "$HARAKA_ROOT/config/smtp_forward.ini"
;enable_outbound=false
host=$SMTP_SERVER
port=$SMTP_PORT
auth_type=login
auth_user=$SMTP_USERNAME
auth_pass=$SMTP_PASSWORD
EOT
cat <<EOT > "$HARAKA_ROOT/config/relay.ini"
[relay]
acl=true
all=true
EOT
cat <<EOT > "$HARAKA_ROOT/config/relay_dest_domains.ini"
[domains]
$SERVER_HOSTNAME = { "action": "continue", "nexthop": "$SMTP_SERVER:$SMTP_PORT" }
EOT

haraka -c "$HARAKA_ROOT"