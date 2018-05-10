# Scheduler

This is a rudimentary service scheduler. The idea is that it looks at what
type of resources are available by listing all consul members, checking
what type of machines they are, and then using that information to
determine what context to pass to the configuration management so the
right things can be installed and services started (or stopped).

