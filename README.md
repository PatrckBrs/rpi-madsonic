#debian Madsonic

Currently using the Madsonic 6.0 BETA

/config  

Home directory for madsonic.  
Your logs and databases will be stored here.

Default environment variable settings (use --e SSL="no" to change values)  

HOST=0.0.0.0  
PORT=4040  
CONTEXT_PATH=/  
MAX_MEMORY=1024  

## Docker run command:

docker run -d -p 4040:4040 -p 4050:4050 --net=host -e SSL="yes" -v /mnt:/mnt -v <path for media files>:/media -v <path for config files>:/config -v /etc/localtime:/etc/localtime:ro --name=madsonic madsonic/debian-madsonic
