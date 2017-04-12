#!/bin/bash
cd /tmp
git clone https://github.com/rbjaxter/budhud.git
cd ~
rm -rf '/home/USERNAMEHERE/.local/share/Steam/steamapps/common/Team Fortress 2/tf/custom/budhud/'
mv /tmp/budhud/budhud/ '/home/USERNAMEHERE/.local/share/Steam/steamapps/common/Team Fortress 2/tf/custom/'
