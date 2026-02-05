#!/bin/bash

echo "Download and extract node exporter, and configure node exporter service"

# renovate: datasource=github-releases depName=prometheus/node_exporter
node_exporter_version="1.10.2"

case $platform in

    "x86-64")
        arch=amd64
        ;;
    "armsr-armv8")
        arch=arm64
        ;;
    *)
        echo "unknown or unspecified platform $platform. Exiting with error"
        exit 1
        ;;
esac

node_exporter_archive_name="node_exporter-$node_exporter_version.linux-$arch"
node_exporter_download_url="https://github.com/prometheus/node_exporter/releases/download/v$node_exporter_version/$node_exporter_archive_name.tar.gz"

echo "Downloading node exporter"
wget -nc $node_exporter_download_url

echo "Extracting node exporter"
tar -zxf $node_exporter_archive_name".tar.gz"
rm $node_exporter_archive_name".tar.gz"

echo "Deploy node exporter binary"
mkdir -p files/usr/bin
cp $node_exporter_archive_name/node_exporter files/usr/bin

node_exporter_init_d_src="https://raw.githubusercontent.com/prometheus/node_exporter/refs/tags/v$node_exporter_version/examples/openwrt-init.d/node_exporter"

echo "Deploy node exporter init.d script"
mkdir -p files/etc/init.d
wget -O files/etc/init.d/node_exporter $node_exporter_init_d_src
chmod +x files/etc/init.d/node_exporter
