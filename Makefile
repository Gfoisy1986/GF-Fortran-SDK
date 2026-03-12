FC = gfortran
CC = gcc

CFLAGS = -Wall -O2
FFLAGS = -Wall -O2

SSL_LIBS = -lssl -lcrypto

SRC_F90 = \
    net/core/tcp.f90 \
    net/core/tls.f90 \
    net/server/router.f90 \
    net/server/tls_server.f90 \
    net/client/tls_module.f90 \
    net/client/tls_client.f90

SRC_C = \
    net/c/tls_wrapper.c \
    net/c/tcp_wrapper.c
OBJ_F90 = $(SRC_F90:.f90=.o)
OBJ_C = $(SRC_C:.c=.o)

BUILD_DIR = build

all: dirs tls_server tls_client

dirs:
	mkdir -p $(BUILD_DIR)

tls_wrapper.o: net/c/tls_wrapper.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

tls_server: tls_wrapper.o net/c/tcp_wrapper.o net/core/tcp.o net/core/tls.o net/server/router.o net/server/tls_server.o
	$(FC) $^ $(SSL_LIBS) -o $(BUILD_DIR)/tls_server

tls_client: tls_wrapper.o net/core/tls.o net/client/tls_client.o
	$(FC) $^ $(SSL_LIBS) -o $(BUILD_DIR)/tls_client

clean:
	rm -f net/**/*.o net/**/*.mod tls_wrapper.o
	rm -rf $(BUILD_DIR)

run_server:
	$(BUILD_DIR)/tls_server

run_client:
	$(BUILD_DIR)/tls_client
