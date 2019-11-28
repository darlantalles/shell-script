#!/bin/bash
#
# Script limpeza forçada dos arquivos temporarios do JbossEAP-6.x
#  
# Use: $0 <argumento>
# 1 - delete [data/, tmp/, log/]
# 2 - delete deployments/
# 3 - kill all process with jboss name
# all - all process
#
# autor: Darlan Talles <darlan.rodrigues@axxiom.com.br>
#
clear
JBOSS_HOME=/home/darlan/Desenvolvimento/G-DIS/Programas/jboss-eap-6.4

limpaPastasTemporarias(){
    echo "limpaPastasTemporarias()"
	rm -rv $JBOSS_HOME/standalone/data/ $JBOSS_HOME/standalone/log/ $JBOSS_HOME/standalone/tmp/ 
}
limpaDeployments(){
    echo "limpaDeployments()"
	rm -rv $JBOSS_HOME/standalone/deployments/*
}
mataProcessosRelacionados(){
	echo "mataProcessosRelacionados()"
    pid_ret=$(ps aux | grep -i $JBOSS_HOME | awk '{print $2}')
    kill $pid_ret
    echo "Encerrando: $JBOSS_HOME" || echo "Nï¿½o foi possivel encerrar: $JBOSS_HOME. Execute: kill -9 $pid_ret." 
}
case $1 in
  1)
     limpaPastasTemporarias 
	 ;;
  2)
     limpaDeployments 
     ;;
  3)
     mataProcessosRelacionados 
     ;;
  all)
      mataProcessosRelacionados; limpaPastasTemporarias ; limpaDeployments 
     ;;
  *)

    echo "Use: $0 <argumento>"
  
    echo "1 - delete [data/, tmp/, log/]"
    echo "2 - delete deployments/"
    echo "3 - kill all process with jboss name"
    echo "all - all process"
esac

