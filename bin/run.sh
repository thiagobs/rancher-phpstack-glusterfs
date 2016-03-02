## GlusterFS
echo "=> Mounting GlusterFS volume ${GLUSTER_VOL} from GlusterFS node ${GLUSTER_NODE_1} ..."
mount -t glusterfs ${GLUSTER_NODE_1}:/${GLUSTER_VOL} /gluster/

mkdir -p /gluster/${NAMESPACE}/www
perl -p -i -e "s/\/gluster\/NAMESPACE\/www/\/gluster\/${NAMESPACE}\/www/g" /etc/nginx/sites-enabled/default

## RUNNING
/usr/bin/supervisord
