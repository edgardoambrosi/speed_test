#!/bin/bash
#t=$(date +"%s"); wget http://speedtest.tele2.net/100MB.zip -O ->/dev/null ; echo -n "MBit/s: "; expr 8 \* 100 / $(($(date +"%s")-$t))

rm /tmp/test
touch /tmp/test
SPEED=0

#numero di byte del file finale scaricato per il test Veloce o Completo
VELOCE=49663734
COMPLETO=99840000

SPEED=97000
COMPLETE=195000

TYPE_TEST=$(zenity  --list  --text "SCEGLI IL TIPO DI TEST!" --radiolist  --column "Scelta" --column "Tipo" FALSE VELOCE TRUE COMPLETO);
if [ "$?" == "1" ];then exit;fi
if [ "$TYPE_TEST" == "VELOCE" ];
	then 
		AMOUNT_OF_FILE=$VELOCE
		AMOUNT_OF_BLOCK=$SPEED
elif [ "$TYPE_TEST" == "COMPLETO" ];
	then 
		AMOUNT_OF_FILE=$COMPLETO
		AMOUNT_OF_BLOCK=$COMLPETE
fi


(
STOP=false
SPEED_NOW="..."
while [ !$STOP ];do 
	if [ $(stat -c '%s' /tmp/test) -lt $AMOUNT_OF_FILE ];then
		PERCENTAGE=$(expr 100 \* $(stat -c "%s" /tmp/test) \/ $AMOUNT_OF_FILE)%;
		echo $PERCENTAGE
		SPEED_NOW="# Test Completato al $PERCENTAGE"
		echo $SPEED_NOW
	else
		PERCENTAGE=100%;
                echo $PERCENTAGE
                SPEED_NOW="# Test Completato al $PERCENTAGE"
                echo $SPEED_NOW
		STOP=true;
	fi	
done 2>&1|zenity --progress --title="Test Connessione" --auto-close --time-remaining --width=200
if [ "$?" == "1" ];then kill $$;fi
)&


SPEED=$(t=$(date +"%s");dd if=<(wget -O- -o /dev/null https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/snapshot/linux-5.8-rc2.tar.gz) of=/tmp/test count=$AMOUNT_OF_BLOCK status=none; echo -n "MBit/s: "; expr 8 \* 100 / $(($(date +"%s")-$t)))

zenity --info --text="Velocita di connessione: $SPEED" --title="Calcolo Terminato" --width="300"

if [ $? == 0 ];then kill $$;fi

