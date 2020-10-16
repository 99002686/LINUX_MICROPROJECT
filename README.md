# LINUX_MICROPROJECT
Shell Script micro project:

    Script should clone a repositories (read from Input.CSV file) which has program files and a make.
    Navigate to repo directory and use make to build the code. Log success/Failure to the Results.CSV file
    Run cppcheck, log the number of errors/warning reported to a separate column in Results.CSV file
    Run Valgrind, log the number of errors/warning reported to a separate column in Results.CSV file
    Run steps 2-4 for each entry in Input.CSV file

Sample Input file and Results files attached

Additional Info that can be logged

    Number of lines of code
    Any other inference that can be done
    
# To Run
Permission: chmod +x micro.sh
./micro.sh

# To Remove files
rm -rf Substring_c Factorial valgrind.txt Result.csv

