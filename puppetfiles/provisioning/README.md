# Personal masterless puppet setup

Puppet recipes with my configuration for headless servers, workstations (desktop with gui) and HTPCs (Kodi)

## Usage

Run once:
```
# use either headless, workstation or htpc
./papply.sh manifests/headless.pp
```

Or as a raptiformica module to boot a cluster:
```
git clone https://github.com/vdloo/raptiformica
make install
raptiformica install vdloo/simulacra
raptiformica spawn
```

