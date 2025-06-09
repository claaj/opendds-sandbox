docker run --rm -it   --name info   --network opendds_net   --ip 172.30.0.3   ubuntu20.04-opendds   bash -c "    
    DCPSInfoRepo \
      -NOBITS \
      -ORBInitRef NameService=corbaloc::172.30.0.2:2809/NameService \
      -ORBEndpoint iiop://172.30.0.3:12345 \
      -ORBVerboseLogging 1 \
      -DCPSDebugLevel 10"