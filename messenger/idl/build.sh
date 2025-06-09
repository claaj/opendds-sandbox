
OUTPUT_PATH=../generated
IDL_FILE_BASENAME=Messenger


rm -rf ${OUTPUT_PATH}/*

# 1. Run TAO
# This generates:
#  - MessengerC.cpp/.h/.inl
#  - MessengerS.cpp/.h
tao_idl -I$DDS_ROOT -I$TAO_ROOT ${IDL_FILE_BASENAME}.idl -o ${OUTPUT_PATH}

# 2. Generate OpenDDS files
# · This generates
#   - MessengerTypeSupport.idl
#   - MessengerTypeSupportImpl.h/cpp
opendds_idl ${IDL_FILE_BASENAME}.idl -o ${OUTPUT_PATH}

# 3. Generates TAO TypeSupport for previous IDL
tao_idl -I$DDS_ROOT -I$TAO_ROOT ${OUTPUT_PATH}/${IDL_FILE_BASENAME}TypeSupport.idl -o ${OUTPUT_PATH}