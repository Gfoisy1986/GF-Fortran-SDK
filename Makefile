# ============================
#   GF‑MECA TLS Makefile
# ============================

FC      = gfortran
CC      = gcc
FFLAGS  = -Wall -O2
CFLAGS  = -Wall -O2
LDFLAGS = -lssl -lcrypto

# Output directory
BUILDDIR = build

# Source files
CORE_F90   = net/core/tcp.f90 net/core/tls.f90
SERVER_F90 = net/server/router.f90 net/server/tls_server.f90
CLIENT_F90 = net/client/tls_client.f90
C_WRAPPERS = net/c/tcp_wrapper.c net/c/tls_wrapper.c

# Object files
CORE_OBJ   = $(CORE_F90:.f90=.o)
SERVER_OBJ = $(SERVER_F90:.f90=.o)
CLIENT_OBJ = $(CLIENT_F90:.f90=.o)
C_OBJ      = $(C_WRAPPERS:.c=.o)

# Targets
SERVER_BIN = $(BUILDDIR)/tls_server
CLIENT_BIN = $(BUILDDIR)/tls_client

# ============================
#   Default target
# ============================
all: $(BUILDDIR) $(SERVER_BIN) $(CLIENT_BIN)

# ============================
#   Build server
# ============================
$(SERVER_BIN): $(C_OBJ) $(CORE_OBJ) $(SERVER_OBJ)
	$(FC) $(C_OBJ) $(CORE_OBJ) $(SERVER_OBJ) $(LDFLAGS) -o $@

# ============================
#   Build client
# ============================
$(CLIENT_BIN): $(C_OBJ) $(CORE_OBJ) $(CLIENT_OBJ)
	$(FC) $(C_OBJ) $(CORE_OBJ) $(CLIENT_OBJ) $(LDFLAGS) -o $@

# ============================
#   Compile Fortran modules
# ============================
%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

# ============================
#   Compile C wrappers
# ============================
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# ============================
#   Create build directory
# ============================
$(BUILDDIR):
	mkdir -p $(BUILDDIR)

# ============================
#   Clean
# ============================
clean:
	rm -f net/**/*.o net/**/*.mod tls_wrapper.o
	rm -rf $(BUILDDIR)

# ============================
#   Rebuild
# ============================
rebuild: clean all
