#!/bin/bash
#It searches on virustotal if the content of a directory have been previously submitted and what is the detection rate for each file
#Usage sh searchVT.sh $directory $resultfilename

sha256deep -r $1 | while read line;
do
 hash=$(echo "$line" | awk -F" " '{print $1}'); filename=$(echo "$line" | awk -F" " '{print $2}');
 dRatio=$(curl -s --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101" --cookie "Cookie: __utma=194538546.2082643930.1442222961.1442224944.1448454097.3; __utmz=194538546.1448454097.3.2.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); VT_PREFERRED_LANGUAGE=en; __utmb=194538546.15.10.1448454097; __utmc=194538546; __utmt=1" --ssl https://www.virustotal.com/en/file/$hash/analysis/ | sed ':a;N;$!ba;s/\n/ /g' | sed 's/ //g' | grep -o "<td>Detectionratio:</td><tdclass=\"text.*\">\([0-9]\)\{1,2\}/\([0-9]\)\{1,2\}</td>" | sed "s/<\/td><tdclass=\"text.*\">/ /g;s/<\(\/\)\{0,1\}td>//g;");
 if [ ! -z "$dRatio"]; then
  echo "$filename $dRatio" >> $2;
 else
  echo "$filename notFound" >> $2
 fi
sleep 1;
done
