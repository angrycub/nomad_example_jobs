# Nomad Java JAR Sample

This sample will download a jarfile and use it to count the words in the
templated text file.

```shell-session
$ nomad run jar-test.nomad
==> Monitoring evaluation "b2d818af"
    Evaluation triggered by job "jar-test.nomad"
==> Monitoring evaluation "b2d818af"
    Evaluation within deployment: "a2ba8e63"
    Allocation "6027314e" created: node "14ab9290", group "java"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "b2d818af" finished with status "complete"
```

```shell-session
$ nomad alloc logs 6027314e
Counted 1515 chars.
```

## Building the source

```shell-session
$ javac --source=7 --target=7 -d bin src/Count.java
$ jar cf jar/Count.jar -C bin .
```

Upload the jarfile where you like and update the source in the artifact stanza
