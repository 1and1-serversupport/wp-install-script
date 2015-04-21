# Script to install wordpress all in one

With this script you can install wordpress all in one. It also creates a 
database and gives the user the rights to use the database.

#### 1. give the script the needed rights to run:
    chmod +x wp-install.sh

#### 2. create a *temporary* file named ".dbpass" and fill it with your mysql root password:
    echo "YourMySQLRootPassword" >> .dbrootpass

#### 3. create a *temporary* file named ".dbname" and another on named ".dbuser":
    echo "YourDatabaseName" >> .dbname
    echo "YourUsername" >> .dbuser
    echo "YourDatabasePassword" >> .dbpass

#### 3. run the script:
    sudo ./wp-install.sh

#### 4. remove the temporary files:
    rm .dbpass .dbname .dbuser .dbrootpass

#### 5. (Optional) remove the script file:
    rm wp-install.sh
