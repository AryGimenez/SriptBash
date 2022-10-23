#!/bin/sh

Buscar(){
    # xSalidaNmap=$(sudo nmap -p 80 --open --script=http-title 192.168.3.0/24)
    # echo "$xSalidaNmap" > Temporal.txt

    mNombre=""
    mIp=""
    mMac=""
    mModelo=""
    mContadorLina=1

    while read line; do 

        # echo "$xline" 
        if echo "$line" | grep -q "Nmap scan report for" # Busca “Nmap scan report for” ya que determina que las siguientes linas son de un host encontrado por NMap
        then
            mIp=$(echo "$line"  | sed 's/Nmap scan report for //') #Saca el “Nmap scan report for” obteniendo el valor que quiero la Ip y el Nombre de el host (si lo tiene ) 

            if echo "$mIp" | grep -q "(" #Busca si el dato obtenido contiene una “(” Ya que en este caso significa que nmap encontro el nombre del host, por lo tanto, tengo que separarlos para obtener el ip por un lado y el host por otro 
            then
                array=( ${mIp// / } ) #Crea un array utilizando el espacio como separador 
                mNombre=${array[0]}
                mIp=$(echo "${array[1]}" | sed 's/^.//;s/.$//')
                
            fi
            mContadorLina=2
        elif [[ $mContadorLina == 6 ]]
        then
            mModelo=$(echo "$line"  | sed 's/|_http-title: //')
            let mContadorLina++
        elif [[ $mContadorLina == 7 ]]
        then        
            array=( ${line// / } ) 
            mMac=${array[2]}
            if echo "$mModelo" | grep -q "Shelly" # 
            then
                echo "|$mModelo|$mIp|$mMac|$mNombre|"
                let mContadorLina++
            fi
            mNombre=""
            mIp=""
            mMac=""
            mModelo=""
        else
            let mContadorLina++
        fi

    done < "Temporal.txt"
}

Buscar
