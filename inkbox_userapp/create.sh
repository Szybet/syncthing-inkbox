#!/bin/bash -x

cd ../

cp syncthing-qt/build/syncthing-qt inkbox_userapp/syncthing/app-bin/syncthing-qt.bin

# Very important
rm -f inkbox_userapp/syncthing.isa.dgst
rm -f inkbox_userapp/syncthing.isa

mksquashfs inkbox_userapp/syncthing/* inkbox_userapp/syncthing.isa

# Yes, here are my private keys. Is providing this info a security threat? no.
openssl dgst -sha256 -sign /home/szybet/inkbox-keys/userapps.pem -out inkbox_userapp/syncthing.isa.dgst inkbox_userapp/syncthing.isa

# Create the zip
cd inkbox_userapp/
rm -rf syncthing.zip
mkdir -p tmp_syncthing_dir/syncthing/
cp app.json tmp_syncthing_dir/syncthing/
cp syncthing.isa tmp_syncthing_dir/syncthing/
cp syncthing.isa.dgst tmp_syncthing_dir/syncthing/
cd tmp_syncthing_dir
zip -r syncthing.zip syncthing/
mv syncthing.zip ../
cd ..
rm -rf tmp_syncthing_dir

servername="root@10.42.0.28"
passwd="root"

sshpass -p $passwd ssh $servername "bash -c \"ifsctl mnt rootfs rw\""
# sshpass -p $passwd ssh $servername "bash -c \"rm -r /data/onboard/.apps/syncthing\""
sshpass -p $passwd ssh $servername "bash -c \"mkdir /data/onboard/.apps/syncthing\""
sshpass -p $passwd ssh $servername "bash -c \"rm  /data/onboard/.apps/syncthing/syncthing.isa\""
sshpass -p $passwd ssh $servername "bash -c \"rm  /data/onboard/.apps/syncthing/syncthing.isa.dgst\""
sshpass -p $passwd ssh $servername "bash -c \"rm  /data/onboard/.apps/syncthing/app.json\""

cd ..
sshpass -p $passwd scp inkbox_userapp/app.json $servername:/data/onboard/.apps/syncthing/
sshpass -p $passwd scp inkbox_userapp/syncthing.isa.dgst $servername:/data/onboard/.apps/syncthing/
sshpass -p $passwd scp inkbox_userapp/syncthing.isa $servername:/data/onboard/.apps/syncthing/

sshpass -p $passwd ssh $servername "bash -c \"touch /kobo/tmp/rescan_userapps\""

sshpass -p $passwd ssh $servername "bash -c \"sync\""

sshpass -p $passwd ssh $servername "bash -c \"killall -9 syncthing-debug.sh\"" || EXIT_CODE=0
sshpass -p $passwd ssh $servername "bash -c \"killall -9 syncthing.sh\"" || EXIT_CODE=0

sshpass -p $passwd ssh $servername "bash -c \"rc-service inkbox_gui restart\"" # to get logs
# sshpass -p $passwd ssh $servername "bash -c \"rc-service gui_apps restart\""

# To update main json
# sshpass -p $passwd ssh $servername "bash -c \"touch /kobo/tmp/rescan_userapps\"" # This gets deleted by service restart
#sshpass -p $passwd ssh $servername "bash -c \"killall inkbox-bin\""
#sleep 10
