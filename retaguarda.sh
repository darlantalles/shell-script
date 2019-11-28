#!/bin/bash

# Script para permitir a execução de um lote de Java applications via background.
#  
# Use: $0 (start|stop|restart|status) [Nome Retaguarda]
#
# Darlan Talles <darlan.rodrigues@axxiom.com.br>
#
clear
RETAGUARDA_HOME=/usr/appjava
JAVA_HOME="/usr/java/jdk1.6.0_45/bin/java" 
JAVA_OPTIONS="-Duser.timezone=America/Sao_Paulo -Xms32M -Xmx128M -jar"

listaRetaguardasRodando(){

	if [ -e $RETAGUARDA_HOME/$1 ] ; then 
		if [ "x$1" == "x" ] ; then
			for i in $(ls -la $RETAGUARDA_HOME/*.ja[r] | awk -F / '{print $4}'); do 
				
				ps aux | grep -i $RETAGUARDA_HOME | grep -i $i > /dev/null
				
				if [ $? == 0 ] ; then
					echo "ON-line: $i"
				else
					echo "OFF-line: $i"
				fi
			done	
		else 
			ps aux | grep -i $RETAGUARDA_HOME | grep -i $1 > /dev/null
			
			if [ $? == 0 ] ; then
				echo "ON-line: $1"
				return 1
			else
				echo "OFF-line: $1"
				return 0
			fi
		fi
	else 
		echo "Retaguarda ''$1''  nao existe no diretorio $RETAGUARDA_HOME"
		exit 1
	fi
}

iniciaRetaguardas(){
	
	pwd_local=`pwd`
	echo "Excluindo $RETAGUARDA_HOME/nohup.out"
	rm -vf $RETAGUARDA_HOME/nohup.out
	cd $RETAGUARDA_HOME
	if [ -e $RETAGUARDA_HOME/$1 ] ; then 
		if [ "x$1" == "x" ] ; then
			for i in $(ls -la $RETAGUARDA_HOME/*.ja[r] | awk -F / '{print $4}'); do 
			
				listaRetaguardasRodando $i > /dev/null
				if [ $? == 0 ] ; then
					nohup $JAVA_HOME $JAVA_OPTIONS $RETAGUARDA_HOME/$i > foo.out < /dev/null &
					echo "Inicializando: $i"
				else
					echo "Ja esta rodando: $i."
				fi
			done
		else 
			listaRetaguardasRodando $1 > /dev/null
				if [ $? == 0 ] ; then
					nohup $JAVA_HOME $JAVA_OPTIONS $RETAGUARDA_HOME/$i > foo.out < /dev/null &
					echo "Inicializando: $i"
				else
					echo "Ja esta rodando: $1."
				fi
		fi
	else 
		echo "Retaguarda '$1'  nao existe no diretorio $RETAGUARDA_HOME"
		exit 1
	fi
	cd $pwd_local
}

paraRetaguardas(){
	
	if [ -e $RETAGUARDA_HOME/$1 ] ; then 
		if [ "x$1" == "x" ] ; then
			for i in $(ls -la $RETAGUARDA_HOME/*.ja[r] | awk -F / '{print $4}'); do 
			
				listaRetaguardasRodando $i > /dev/null
				if [ $? == 0 ] ; then
					echo "Estava parada: $i"
				else
					pid_ret=$(ps aux | grep -i $RETAGUARDA_HOME[/]$i | awk '{print $2}') 
					kill $pid_ret
					[ $? == 0 ] && echo "Encerrando: $i" || echo "$Nao foi possivel encerrar: $i. Execute: kill -9 $pid_ret."
				fi
			done
		else 
			listaRetaguardasRodando $1 > /dev/null
			if [ $? == 0 ] ; then
				echo "Esta retaguarda ja nao estava rodando anteriormente."
			else
				pid_ret=$(ps aux | grep -i $RETAGUARDA_HOME[/]$1 | awk '{print $2}') 
				kill $pid_ret
				[ $?  == 0 ] && echo "Encerrando: $1" || echo "Não foi possivel encerrar: $1. Execute: kill -9 $pid_ret."
			fi
		fi
	else 
		echo "Retaguarda ''$1''  nao existe no diretorio $RETAGUARDA_HOME"
		exit 1
	fi
}



case $1 in
  status)
     listaRetaguardasRodando $2
	 ;;
  start)
     iniciaRetaguardas $2
     ;;
  stop)
     paraRetaguardas $2
     ;;
  on)
     listaRetaguardasRodando | grep -i ON[-]line && echo "" || echo "Não existem retaguardas On-line."
     ;;
  off)
     listaRetaguardasRodando | grep -i OFF[-]line && echo "" || echo "Não existem retaguardas Off-line."
     ;;
  *)
    echo "Use: $0 (start|stop|restart|status) [Nome Retaguarda]" 1>&2
	
	exit 1
esac

