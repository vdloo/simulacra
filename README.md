simulacra
=========

My personal decentralized grid computing network

This repository contains the declarative blueprints for my self-organising 
network of heterogeneous machines and the tasks they perform. The network 
consists of laptops, desktops, (cloud) servers, and mobile phones.

## Concepts

These are some of the ideas that I want to try to implement with this
project eventually. Previously I've created [raptiformica](https://github.com/vdloo/raptiformica) and [jobrunner](https://github.com/vdloo/jobrunner) 
to help facilitate an environment in which these ideas become easier to 
implement in a decentralized environment with ephemeral and fast moving 
machines like mobile devices. This project builds on top of those tools.

### Dynamic resource allocation

If a machine is online and can be reached by any of the other machines in 
the network, the resources should be available to the cluster. If not enough 
resources are available for the tasks in the cluster, more machines should be 
made available (autoscaling), either through` `Wake-on-LAN` of known hardware 
or by booting cloud servers. Conversely, when there is not enough work to 
justify the amount of running machines, the grid should shut down superfluous 
machines to save electricity.

### Resource based task scheduling

Depending on the current size and capacity of the grid, some tasks or
services might become feasible to run or come online. For example, it does
not make sense to run a Jenkins for testing if the grid is surviving on
a cluster of mobile phones. But if in the cluster a hypervisor exists,
that might be used to perform such tasks. In that case it would make sense
to schedule that service by means of some automatic mechanism.

### Zone based task scheduling

While the network is completely decentralized and all nodes can reach all
nodes as long as any node can reach any node (through the overlay
network), it would still make sense to run services in duplicate in
different zones. If a couple of servers are in one zone, and some other
services are in some other zone and the connection between these two
networks would be severed, a netsplit would occur. In that case it would
be better if services that require that level of redundancy would be
preventively scheduled with one in each zone by some heuristic. Otherwise
the chance is higher that two instances of a service are scheduled in
the same half of a split network.

### Proxying peripheral resources and services

There are parts of my network on which I do not want or can't run
[raptiformica](https://github.com/vdloo/raptiformica) natively. These 
are things like web services on embedded machines like IOT devices or 
machines not running Linux. In those cases the devices that can access 
those services through their local network should make those available 
to the rest of the machines by proxying it through the overlay network.


# Usage

Clone the project:
```
git clone https://github.com/vdloo/simulacra
cd simulacra
```

Download the jobrunner subproject
```
chmod u+x setup.sh
./setup.sh
```

And then create the virtualenv and install the dependencies as described [here](https://github.com/vdloo/jobrunner#usage).
