if [ `id -u` -eq 0 ];then
	echo 'welcome';
else
	echo 'not root';
	exit;
fi
df -h;
echo 'disk path:(df -h):':
read diskName;
if [[ "$diskName" == "" ]]; then
    echo 'diskName is empty';
    exit 0;
fi

echo 'ios path:';
read isoFile;
if [[ "$isoFile" == "" ]]; then
    echo 'iosfile is empty';
    exit;
elif [[ ! -f "$isoFile" ]]; then
    echo 'iosfile is not exists ';
    exit;
fi
echo "$isoFile => $diskName (y/n?)";
read ok;

if [[ "$ok" != "y" ]]; then
    echo 'canncel';
    exit;
fi

umount $diskName;
diskutil umount $diskName;

pv --version
returnCode="$?"

if [[ "$returnCode" != "0" ]]; then
    echo "dd bs=4m if=$isoFile of=$diskName;"
    dd bs=4m if=$isoFile of=$diskName;
else
    echo "pv -cN source < $isoFile | dd bs=4m of=$diskName"
    pv -cN source < $isoFile | dd bs=4m of=$diskName
fi
echo 'finished';
#dd if=/Volumes/yulongjun-7/iso_image/Fedora-Live-Workstation-x86_64-21-5.iso  of=/dev/disk2
