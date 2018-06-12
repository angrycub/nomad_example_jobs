# Creating a nginx configuration from fabio-style tagging

### Files
* foo-service.nomad - the foo job.  Exercises the path stripping
* bar-service.nomad - the bar job
* tj.out = john's template rendered  works, but fugly
* tj.ct = john's template
* e.ct example consul template  trying to be fancy af
* e.out rendered template

### Render template

```
consul-template --template="e.ct:e.out" --once
```
