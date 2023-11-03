Examples of using services in `template` output

Let's face it, Go's text/template engine is not the easiest thing to walk up to
and use. This is made worse because out of the box it has rather limited
functionality and requires that integrators bring almost all the functions
users expect when writing templates. To that end, Nomad uses consul-template
which brings a significant number of helper functions. Consul-template,
hereafter referred to as CT, provides formatting functions, generative functions,
and even functions that return live data from Consul, Vault, and Nomad.

This example section will look at the functions that return service data from
Consul and Nomad.

## The jobs

To create the sample service output, there are a few provided job specifications.
These specifications are configured to run a relatively light container that
doesn't do anything except to serve as a place to connect a service.

- **services.nomad** - This simple job will create a given number of instances,
  set by `count` in the job specification itself.

- **dynamic.nomad** - This job specification uses HCL2 dynamic blocks to create
  a given number of instances that use sequential ports.

- **byTag.nomad** - (**Requires Consul)** This job specification runs a job and
  creates a Consul service. It then outputs a template with information ordered
  using the `byTag` helper for Consul services.

## The templates

- **t1.tmpl** - This template is a cookbook for working with Nomad services using
  the `nomadService` function. You can run it directly in consul-template or
  include it as the body of a template in a Nomad job
