#!/bin/bash
RESULT="./Result.csv"
INPUT_DIR="../Microproject/Input.csv"
printf "Name,Email_ID,Repo_link,clone,build,cppcheck,valgrind,error\n" > $RESULT
TEMPIFS=$IFS
IFS=','
[ ! -f $INPUT_DIR ] && { echo "$INPUT_DIR not found!"; exit 99; }

while IFS=',' read Name Email_ID Repo_link;
do
    if [ $Name != "Name" ]; then
        printf "$Name," >> $RESULT 
    fi
    if [ $Email_ID != "Email_ID" ]; then
        printf "$Email_ID," >> $RESULT
    fi 
    if [ $Repo_link != "Repo_link" ] && printf "$Repo_link," >> $RESULT; then
        name=$Name 
        mail=$Email_ID 
        link=$Repo_link 
    
        REPO_NAME=`echo "$link" | cut -d'/' -f5`
        echo "REPONAME = $REPO_NAME"
        git clone $link
        [[ $? == 0 ]] && printf "CLONE PASSED," >> $RESULT
        [[ $? > 0 ]] &&  printf "CLONE FAILED," >> $RESULT 

        echo "BUILD"
        #BUILD=`find $REPO -name "Makefile"` && cd $BUILD
        MAKE=`find $REPO_NAME -name "Makefile" -exec dirname {} \;`
        echo "MAKE = $MAKE"
        make -C $MAKE
        [[ $? == 0 ]] && printf "MAKE SUCCESS," >> $RESULT
        [[ $? > 0 ]] && printf "MAKE FAIL," >> $RESULT

        echo "CPPCHECK"
        #BUILD_DIR=cd .. && echo $BUILD_DIR
        cppcheck --force $REPO_NAME 
        [[ $? == "0" ]] && printf "CPPCHECK SUCCESS," >> $RESULT
        [[ $? > "1" ]] && printf "CPPCHECK FAILURE," >> $RESULT

        sleep 2 --

        echo "Valgrind"
        VALOUT=`find $REPO_NAME -name "TEST*.out"`
        echo "VALOUT = $VALOUT"
        valgrind --leak-check=full $VALOUT 2>> valgrind.txt
        if [ $? == 0]; then
            printf "VALGRIND SUCCESS," >> $RESULT
        else
            printf "VALGRND FAIL," >> $RESULT
        fi
        STATUS=`tail -n 1 valgrind.txt` && error=$(echo ${STATUS:24:3})
        printf "$error\n" >> $RESULT
    fi
done < $INPUT_DIR
IFS=$TEMPIFS


