## From Template

This sample will use Consul KV to hold a template for a job rather than embedding
it in the jobfile itself.  There will need to be a small wrapper template to pull
and execute the fetched template.


```
$ consul kv put template/test "{{printf \"this is from consul's template\"}}"
```

```
Success! Data written to: template/test
```

### issue.nomad

This example demonstrates what happens when you try to reference a KV value's
contents as a template inside of another template—basically nothing. You will
receive unrendered template as output.

```
➜ nomad alloc logs 898a69d7-9593-3ca0-c258-2500b6656122
{{printf "this is from consul's template"}}
```

### artifact.nomad

This example demonstrates using the `artifact` stanza to do a direct call to the
Consul API to fetch the KV value into a local file to be run on the Nomad client.

Pros: Not terribly complicated, works much like you would expect.

Cons: Needs a separate token in the workload, unless the path can be reached by:
    - the Consul agent receiving the API call's token
    - the anonymous token

### init.nomad