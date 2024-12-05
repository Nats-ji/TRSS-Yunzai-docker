#!/bin/sh

if ! [ $(id -u) = 0 ]; then
   echo "The script needs to be run with sudo." >&2
   exit 1
fi

mkdir -p backups
OUTPUT_NAME="./backups/yunzai-backup-$(date '+%Y-%m-%d').tar.gz"
TOTAL_SIZE=`du -sk --apparent-size --total yunzai/ | cut -f 1 | tail -n 1`
CHECKPOINT=`echo ${TOTAL_SIZE}/50 | bc`
echo "Creating backup file. Total size: $(numfmt --to=iec $(echo ${TOTAL_SIZE}*1000 | bc))."
echo "Estimated: [==================================================]"
echo -n "Progess:   ["
tar -c --record-size=1K --checkpoint="${CHECKPOINT}" --checkpoint-action="ttyout=>" -f - yunzai/ | gzip > $OUTPUT_NAME
echo "]"
echo "Done"
chown $SUDO_USER:$(id -gn $SUDO_USER) $OUTPUT_NAME
ls --color -hl "${OUTPUT_NAME}"*