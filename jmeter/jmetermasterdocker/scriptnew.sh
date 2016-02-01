#!/bin/bash
#unset -f arrayname;
declare -a arrayname=();

#to remove all unstopped  jmeter containers of image jmeter
docker rm -f -v $(docker ps -a -q -f image=jmeter*)


export workspace=$1
export number=$2
export hostip=$3
export hostname=$4

docker pull www.cybage-docker-registry.com:9080/jmeterslave00
docker pull www.cybage-docker-registry.com:9080/jmetermaster01

echo $2;

#export host=dev.alm-task-manager.com


b=0;
ip='';

#declare -a arrayname=();

#declare -a arrayname=();

while [ $b -lt $2 ]
do
  echo $b


docker run --name jmeterslave$b -d  -e HOSTNAMES=$hostname -e HOSTIP=$hostip www.cybage-docker-registry.com:9080/jmeterslave00
sleep 10s;
echo "fetching slave containers IP and storing it into variable a and variable b";
echo  $(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave$b )



if [ -z  $(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave$b ) ] ; then
echo "slave not up "
b=`expr $b + 1`
#break;

else
ipnew=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave$b )
arrayname=("${arrayname[@]}" "$ipnew");
  #export host=dev.alm-task-manager.com
   b=`expr $b + 1`

fi
done


x=$(IFS=,;printf  "%s" "${arrayname[*]}")
echo "$x"


echo "hiiiiiiiiiiiiiiiiiiiiiiii"
echo $x;














#while [ $a -lt $2 ]
#do
#  echo $a
#  docker run --name jmeterslave$a -d  -e HOSTNAMES=$hostname -e HOSTIP=$hostip www.cybage-docker-registry.com:9080/jmeterslave00

 # echo "fetching slave containers IP and storing it into variable a and variable b";

  #ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' jmeterslave$a ),$ip

  #echo $ip
  ##export host=dev.alm-task-manager.com
  # a=`expr $a + 1`

#done



echo -e "\t\n\n\n\n\n\n\t ###############################################";
echo $ip;
echo -e "\t\n\n\n\n\n\n\t #######value of $p ########################################";

#ip1=${ip%?}

#echo $ip1
#docker run --name jmetermaster -d -v $workspace:/reports -e IP=$ip -e HOSTIP=$hostip  HOST_NAMES=$hostname  www.cybage-docker-registry.com:9080/jmetermaster00


if [ -z $x ]
then
echo "no container available " 
echo $x;
exit 1
fi

docker run --name jmetermaster -d -v $workspace:/reports -e IP=$x -e HOSTIP=$hostip -e  HOSTNAME=$hostname  www.cybage-docker-registry.com:9080/jmetermaster01





