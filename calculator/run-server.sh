docker run --rm -it \
    --name calculator_server \
    --network opendds_net \
    --ip 172.30.0.3 \
    -v "$PWD/build:/workspace" \
    -w /workspace \
    ubuntu20.04-opendds \
    ./calculator_server \
    -ORBInitRef NameService=corbaloc::172.30.0.2:2809/NameService
