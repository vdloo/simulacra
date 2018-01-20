#/usr/bin/env sh
if [ "$(id -u)" != "0" ]; then
	echo 'run this script as root';
else
	dirname=$(dirname "$0");
	hieraconfig="$dirname/hiera/hiera.yaml"
	base=$(puppet master --configprint modulepath);
	modulepath="$base:$dirname/modules:$dirname/roles:$dirname/operating_systems" 
	puppet apply --verbose --debug --modulepath="$modulepath" --hiera_config=$hieraconfig "$@"; 
fi
