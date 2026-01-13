# Prometheus


On the client, you will need a rule to allow the Docker containers to talk to the local
Consul agents.

```
firewall-cmd --permanent --zone=public --add-rich-rule='rule family=ipv4 source address=172.17.0.0/16 accept' && firewall-cmd --reload
```


## Connecting to the instances


