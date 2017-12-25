# Test environment

This is a Terraform template that creates the test env on my hypervisor,
using libvirt to drive KVM/Qemu. This script assumes that the pre-baked
image `/home/vdloo/images/grid0.qcow2` exists.

## Usage

1. Make sure [go](https://golang.org/) is installed
1. Make sure [terraform](http://terraform.io/) is installed
1. `go get github.com/dmacvicar/terraform-provider-libvirt`
1. `go install github.com/dmacvicar/terraform-provider-libvirt`
1. copy `$GOPATH/go/bin/terraform-provider-libvirt` to `$HOME/.terraform.d/plugins`
1. Run `terraform apply` in `simulacra/terraform`

