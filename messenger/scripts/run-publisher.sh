docker run --rm -it \
  --name publisher \
  --network opendds_net \
  --ip 172.30.0.5 \
  -v "$PWD/build:/workspace" \
  -w /workspace \
  ubuntu20.04-opendds \
  ./publisher \
    -ORBInitRef NameService=corbaloc::172.30.0.2:2809/NameService \
    -DCPSInfoRepo corbaloc::172.30.0.3:12345/DCPSInfoRepo \
    -DCPSDebugLevel 10 \
    -DCPSTransportDebugLevel 6 \
    -ORBVerboseLogging 1 \
    -DCPSPendingTimeout 5
