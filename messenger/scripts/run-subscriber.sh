docker run --rm -it \
  --name subscriber \
  --network opendds_net \
  --ip 172.30.0.4 \
  -v "$PWD/build:/workspace" \
  -w /workspace \
  ubuntu20.04-opendds \
  ./subscriber \
    -ORBInitRef NameService=corbaloc::172.30.0.2:2809/NameService \
    -DCPSInfoRepo corbaloc::172.30.0.3:12345/DCPSInfoRepo \
    -DCPSDebugLevel 0 \
    -DCPSTransportDebugLevel 0 \
    -ORBVerboseLogging 0 \
    -DCPSPendingTimeout 5
