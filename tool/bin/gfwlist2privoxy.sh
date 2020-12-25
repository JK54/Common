#!/bin/bash
#modified from https://samzong.me/2017/11/17/howto-use-ssr-on-linux-terminal/
proxy="127.0.0.1:1080"

tee /tmp/gfw.action << EOF
{+forward-override{forward-socks5 $proxy .}}
EOF

curl -sL https://raw.github.com/gfwlist/gfwlist/master/gfwlist.txt | base64 -d > /tmp/gfwlist.txt

cat /tmp/gfwlist.txt | \
egrep -v '^!|^$|^@@|^\[' | \
sed -r 's@^\|\|([^\|].*)@\1@g' | \
sed -r 's@^\|\w+://(.*)@\1@g' \
> /tmp/gfwlist_clean

cat /tmp/gfwlist_clean | egrep '^\/' > /tmp/gfwlist_regexp

cat /tmp/gfwlist_clean | egrep '^[^\/]+\/.*(\*|\?).*' > /tmp/gfwlist_uri_glob

cat /tmp/gfwlist_clean | egrep -v -e '^\/' -e '^[^\/]+\/.*(\*|\?).*' > /tmp/gfwlist_normal

cat /tmp/gfwlist_uri_glob | sed -r 's@\*@\.\*@g;s@\?@\.@g' >> /tmp/gfw.action

cat /tmp/gfwlist_normal >> /tmp/gfw.action

echo -e '.blogspot.\n.google.\ntwimg.edgesuite.net//?appledaily' >> /tmp/gfw.action

# echo -e '\n============================================================\n'
# echo -e 'Add the following output address to gfw.action please.\nIt need to convert to privoxy format, see privoxy document: https://www.privoxy.org/user-manual/actions-file.html#AF-PATTERNS\n'
# echo -e "file: `pwd`/gfwlist_regexp\n"
# cat gfwlist_regexp

rm -fr /tmp/gfwlist.txt /tmp/gfwlist_clean /tmp/gfwlist_regexp /tmp/gfwlist_normal /tmp/gfwlist_uri_glob

# rm /etc/privoxy/gfw.action
mv /tmp/gfw.action /etc/privoxy/
