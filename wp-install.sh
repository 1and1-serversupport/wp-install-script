#/bin/bash


# This script installs Wordpress and creates a database with all rights and users.
# 21.04.2015

# This script can only be run as root, so check if you are root:
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

# Fill in your wanted domain:
domain=jira.learning-and-testing.de

# Provide the full path to your webspace:
path=/home/denis/web/jira.learning/public_html
mkdir -p $path

# Variables to create the database with user and privileges:
dbname=`cat .dbname`
dbuser=`cat .dbuser`
dbpass=`cat .dbpass`
dbrootpass=`cat .dbpass`
db="create database $dbname;GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost IDENTIFIED BY '$dbpass';FLUSH PRIVILEGES;"

# Variables to get and unzip wordpress
wp_download=`wget https://wordpress.org/latest.zip`
wp_move=`mv wordpress/* $path`
cd $path
wp_config_copy=`cp wp-config-sample.php wp-config.php`

# download, move and copy the config
$wp_download 
unzip latest.zip 
$wp_move 
$wp_config_copy

# Create the database:
mysql -u root -p$dbrootpass -e "$db"

# Replace the default placeholder with your values:
find . -type f -name wp-config.php -exec sed -i 's/database_name_here/'$dbname'/g' {} \;
find . -type f -name wp-config.php -exec sed -i 's/username_here/'$dbuser'/g' {} \;
find . -type f -name wp-config.php -exec sed -i 's/password_here/'$dbpass'/g' {} \;

# Create the default vHost for wordpress
echo "<VirtualHost *:80>

	ServerName www.$domain
	ServerAlias $domain
	DocumentRoot $path

#	DirectoryIndex index.php index.html index.htm
	     
	<Directory $path>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride all
		Order allow,deny
		allow from all
	</Directory>
	
	ErrorLog /var/log/apache2/error.log
		LogLevel warn
		CustomLog /var/log/apache2/access.log combined
		ServerSignature On

</VirtualHost>" >> /etc/apache2/sites-available/$domain.conf

# Enable vHost and reload apache:
/usr/sbin/a2ensite $domain.conf && service apache2 reload

# chown the files so apache can use them:
chown -R www-data.www-data $path

echo "Done. You have successfully created a wordpress. You can reach it at $domain."
