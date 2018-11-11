#!/bin/sh
set -eu

cd /opt/etherpad
echo -e "\n\n[i] Install awesome plugins \n"
npm install \
	ep_adminpads \
	ep_font_color \
        ep_headings2 \
	ep_historicalsearch \
	ep_horizontal_line \
        ep_markdown \
	ep_markdownify \
	ep_offline_edit \
	ep_page_view \
	ep_spellcheck \
	ep_timesliderdiff

exit 0
