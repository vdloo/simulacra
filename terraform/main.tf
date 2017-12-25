provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "grid-qcow2" {
  name = "grid${count.index}-qcow2"
  pool = "default"
  format = "qcow2"
  source = "/home/vdloo/images/grid0.qcow2"
  count = 5
}

resource "libvirt_domain" "grid" {
  name = "grid${count.index}"
  memory = "10240"
  vcpu = 2

  network_interface {
    macvtap = "enp0s31f6"
  }
  boot_device {
    dev = ["hd"]
  }
  disk {
    volume_id = "${element(libvirt_volume.grid-qcow2.*.id, count.index)}"
  }
  graphics {
    type = "vnc"
    listen_type = "address"
  }
  count = 5
}

