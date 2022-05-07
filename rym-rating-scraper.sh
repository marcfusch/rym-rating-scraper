#!/bin/bash
input="$1"
outfile="$2"
totallines=$(cat $1 | wc -l)


request(){
  curl -s "${url}" \
    -H 'authority: rateyourmusic.com' \
    -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
    -H 'accept-language: en-US,en;q=0.9,fr-FR;q=0.8,fr;q=0.7' \
    -H 'cache-control: max-age=0' \
    -H 'cookie: _pbjs_userid_consent_data=3524755945110770; sec_bs=bbb8c6ad73d76c185fc5de73b0037dbe; sec_ts=1651935299; sec_id=ccc90f5880d27a2b2ba2af9296c4060c' \
    -H 'dnt: 1' \
    -H 'sec-fetch-dest: document' \
    -H 'sec-fetch-mode: navigate' \
    -H 'sec-fetch-site: none' \
    -H 'sec-fetch-user: ?1' \
    -H 'sec-gpc: 1' \
    -H 'upgrade-insecure-requests: 1' \
    -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36' \
    --compressed
}

echo "\"rating\",\"deviation\",\"total\",\"names\"" > "${outfile}"
echo "$totallines users are going to get scraped."
for ((i=1; i<=(totallines+1); i++)); do
  currentline=$(sed -n ${i}p $input)
  currentline=$(echo $currentline | sed -e 's/\r//g')
  url="https://rateyourmusic.com/stats/userstats?user="$currentline
  output=$(request | grep "Average Rating" 2>/dev/null;)
  if [ -z "$output" ]
  then
      echo "IP banned, please change your IP address in order to continue scraping!"
      echo "Or complete the captcha in your browser, and change the session cookie into the request functio"
      exit
  fi
  output=$(sed 's\<b>Average Rating:</b> \\g' <(echo $output))
  output=$(sed 's\ stars | <b>Standard Deviation:</b> \ \g' <(echo $output))
  output=$(sed 's\ stars | <b>Total stars given:</b> \ \g' <(echo $output))
  output=$(sed 's|\.|,|g' <(echo $output))
  echo "\"$(echo $output | awk '{print $1}')\",\"$(echo $output | awk '{print $2}')\",\"$(echo $output | awk '{print $3}')\",\"$currentline\"" >> "${outfile}";
  echo "$output $currentline"
  wait $!
  sleep $[ ( $RANDOM % 6 )  + 2 ]s
done
echo "Scraping complete."
echo "CSV filed saved as: $outfile"

