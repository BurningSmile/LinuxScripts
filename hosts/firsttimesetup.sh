#!/bin/bash
mkdir ~/.scripts
cd ~/.scripts
git clone --depth 2 https://github.com/StevenBlack/hosts.git
cd ~/.scripts/hosts

cat <<EOT >> myhosts

0.0.0.0 pinion.gg
0.0.0.0 bin.pinion.gg
0.0.0.0 blog.pinion.gg
0.0.0.0 cdn.pinion.gg
0.0.0.0 crm.pinion.gg
0.0.0.0 cp.pinion.gg
0.0.0.0 delivery.pinion.gg
0.0.0.0 docs.pinion.gg
0.0.0.0 kermit.pinion.gg
0.0.0.0 legacy.pinion.gg
0.0.0.0 log.pinion.gg
0.0.0.0 mail.pinion.gg
0.0.0.0 motd.pinion.gg
0.0.0.0 ns1.pinion.gg
0.0.0.0 ns2.pinion.gg
0.0.0.0 ns3.pinion.gg
0.0.0.0 ns4.pinion.gg
0.0.0.0 ns5.pinion.gg
0.0.0.0 ns6.pinion.gg
0.0.0.0 pinionprizes.gg
0.0.0.0 pog.gg
0.0.0.0 pog.pinion.gg
0.0.0.0 stage.pinion.gg
0.0.0.0 templ4d2.pinion.gg
0.0.0.0 tix.pinion.gg
0.0.0.0 video.pinion.gg
0.0.0.0 voip.pinion.gg
0.0.0.0 wiki.pinion.gg
#02 Feb 2013 update
0.0.0.0 oscar.pinion.gg
0.0.0.0 ads.intergi.com
#6 March 2013 update
0.0.0.0 adback.pinion.gg
#7 June 2014 update
0.0.0.0 api.pinion.gg
0.0.0.0 bork.pinion.gg
0.0.0.0 calendar.pinion.gg
0.0.0.0 direct.pinion.gg
0.0.0.0 immuniser.pinion.gg
0.0.0.0 mailer.pinion.gg
0.0.0.0 office.pinion.gg
0.0.0.0 pinion-log.pinion.gg
0.0.0.0 quartermaster.pinion.gg
0.0.0.0 seen.pinion.gg
0.0.0.0 transcoded.pinion.gg
0.0.0.0 www.pinion.gg
#24 Dec 2016 update
0.0.0.0 cf-protected-bin.pinion.gg
0.0.0.0 cp-ng.pinion.gg
0.0.0.0 creative.pinion.gg
0.0.0.0 git.pinion.gg
0.0.0.0 pog2.pinion.gg
0.0.0.0 transcoder.pinion.gg
#this company purchased pinion and some trackers are stored there now
0.0.0.0 unikrn.com
0.0.0.0 www.unikrn.com
0.0.0.0 affiliates.unikrn.com
0.0.0.0 auctionbot.unikrn.com
0.0.0.0 blog.unikrn.com
0.0.0.0 cdn.unikrn.com
0.0.0.0 http.unikrn.com
0.0.0.0 intranet.unikrn.com
0.0.0.0 jira.unikrn.com
0.0.0.0 logs.unikrn.com
0.0.0.0 mcemails.unikrn.com
0.0.0.0 news.unikrn.com
0.0.0.0 news-static.unikrn.com
0.0.0.0 static.unikrn.com
0.0.0.0 stats.unikrn.com
0.0.0.0 t.unikrn.com
0.0.0.0 wiki.unikrn.com

EOT

python3 updateHostsFile.py --auto --replace  --extensions porn gambling fakenews
