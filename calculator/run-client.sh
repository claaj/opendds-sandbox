docker run --rm -it \
           --name calculator_client \
           --network opendds_net \
           --ip 172.30.0.4 \
           -v "$PWD/build:/workspace" \
           -w /workspace \
           ubuntu20.04-opendds \
           ./calculator_client -ORBInitRef NameService=corbaloc::172.30.0.2:2809/NameService
