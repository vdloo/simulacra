provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "grid-qcow2" {
  name = "grid${count.index}-qcow2"
  pool = "default"
  format = "qcow2"
  source = "/home/vdloo/images/grid0.qcow2"
  count = 20
}

resource "libvirt_domain" "grid" {
  name = "grid${count.index}"
  memory = "1024"
  vcpu = 1

  network_interface {
    network_name = "default"
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
  count = 20
}

