# sleepy_python

Background : The Python interpreter buffers output to sys.stdout by default. We have to flush this buffer regularly in order to see this output using the `nomad alloc logs ...` or Nomad web UI.

Solution : do sys.stdout.flush() after write
