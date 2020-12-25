#!/bin/bash

clang++ ./src/main.cpp ./lib/boost/boost_test.cpp ./lib/boost/program_options.cpp ./lib/boost/tcp_async_server.cpp ./lib/others/fast_pow.cpp -g -L$BOOST_PATH/lib -lboost_program_options -lboost_filesystem -lboost_regex -lboost_date_time -lrt -pthread -DUSE_MYMATH
