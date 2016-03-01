#!/bin/sh
apt-get update
apt-get -y install privoxy
echo "Configuring privoxy..."
/etc/init.d/privoxy stop
sed -i 's/listen-address\s.*localhost:8118/listen-address 0.0.0.0:8118/' /etc/privoxy/config
sed -i 's/enable-remote-toggle\s.*0/enable-remote-toggle 1/' /etc/privoxy/config
sed -i 's/enable-edit-actions\s.*0/enable-edit-actions 1/' /etc/privoxy/config
sed -i 's/accept-intercepted-requests\s.*0/accept-intercepted-requests 1/' /etc/privoxy/config
echo "forward-socks4a / 127.0.0.1:9050 .">>/etc/privoxy/config
echo "forward          .i2p            127.0.0.1:4444">>/etc/privoxy/config
echo "forward-socks4a  .onion          127.0.0.1:9050 .">>/etc/privoxy/config
systemctl enable privoxy
systemctl start privoxy
