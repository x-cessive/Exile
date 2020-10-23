# Exile 64bit Edition How to install (Fork from Cloudhax23/Exile)
1. Open your @ExileServer Folder and delete the following files : extDB2.dll , extDB2.so , extDB2-conf.ini , XM8.dll , XM8.so
2. Download the git release of the Exdb3 Exile patch (https://github.com/BrettNordin/Exile) Press the clone/download button.
3. Copy the Exile server file into the server directory
4. Copy the exile mission folder CONTENTS INTO your mission file.
5. open your config.cpp and do the following:

In your config.cpp 
Add: #include "CfgExileCustomCode.cpp" 
Into:
class CfgExileCustomCode 
{
};

It will look like this in the end: 
class CfgExileCustomCode 
{
    #include "CfgExileCustomCode.cpp" 
};

6. Go to Torndeco's download center and download the latest version of extDB3. (https://bitbucket.org/torndeco/extdb3/downloads/)
7. Copy the TWO tbbmalloc.dll's (tbbmalloc.dll, tbbmalloc_x64.dll) to your server ROOT directory
8. Copy the contents of the @extdb3 folder into your @ExileServer Folder
9. Edit the extdb3-conf.ini file, REMEMBER TO CHANGE [Default] to [exile] . Change the database information to be correct (Example: https://gyazo.com/31cb26f08f9cc4b05360915f5ed84303)
10. Exit the Exile.ini file to match any changes in your older exile.ini
 SIDENOTE: the new exile.ini no longer contains the lines with "Number of Inputs = #" (# is refering to any number within the file on this line)
11. Run the Mysql Querys in the "Exile_Database_Update_64x.sql" file to properly update your database.
12. Boot up your server and see if it works. If it does not work then go to your logs folder and find the error code and leave a message here and I'll get to you.

If you run into trouble you can look in the Examples folder and see what the mission file should look like with just the overrides installed. 
