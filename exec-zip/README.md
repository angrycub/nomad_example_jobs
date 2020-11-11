## exec-zip

This sample creates an exec job that downloads a tarball artifact with directory permissions set.  This should enable the jailed user to write into the writable file, but not the non-writable one.


```
[root@nomad-server-1 exec-zip]# tar -tvf folder.tgz 
drwxr-xr-x root/root         0 2018-04-05 15:05 ./folders/
drwxrwxrwx root/root         0 2018-04-05 15:14 ./folders/writable/
-rwxrwxrwx root/root         0 2018-04-05 15:14 ./folders/writable/file1.txt
drwxr-xr-x root/root         0 2018-04-05 15:14 ./folders/not-writable/
-rw-r--r-- root/root         0 2018-04-05 15:14 ./folders/not-writable/file1.txt
-rw-r--r-- root/root         0 2018-04-05 15:14 ./folders/not-writable/file2.txt
```

```
[root@nomad-client-3 folder]# ls -alR folders
folders:
total 0
drwxr-xr-x. 4 root root 42 Apr  6 12:27 .
drwxr-xr-x. 3 root root 21 Apr  6 12:27 ..
drwxr-xr-x. 2 root root 40 Apr  6 12:27 not-writable
drwxr-xr-x. 2 root root 23 Apr  6 12:27 writable

folders/not-writable:
total 0
drwxr-xr-x. 2 root root 40 Apr  6 12:27 .
drwxr-xr-x. 4 root root 42 Apr  6 12:27 ..
-rw-r--r--. 1 root root  0 Apr  6 12:27 file1.txt
-rw-r--r--. 1 root root  0 Apr  6 12:27 file2.txt

folders/writable:
total 0
drwxr-xr-x. 2 root root 23 Apr  6 12:27 .
drwxr-xr-x. 4 root root 42 Apr  6 12:27 ..
-rwxrwxrwx. 1 root root  0 Apr  6 12:27 file1.txt
[root@nomad-client-3 folder]# 
```

