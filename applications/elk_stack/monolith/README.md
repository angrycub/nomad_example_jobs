

```
sudo sysctl -w vm.max_map_count=262144
```

```
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.d/local.conf > /dev/null
sudo service procps force-reload
```
