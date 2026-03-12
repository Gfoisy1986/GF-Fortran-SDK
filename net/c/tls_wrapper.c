#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>

#include <openssl/ssl.h>
#include <openssl/err.h>

static SSL_CTX *ctx = NULL;

/* ---------------------------------------------------------
   Initialize OpenSSL (required before any TLS operations)
   --------------------------------------------------------- */
void tls_init(void) {
    SSL_library_init();
    SSL_load_error_strings();
    OpenSSL_add_all_algorithms();

    ctx = SSL_CTX_new(TLS_method());
    if (!ctx) {
        ERR_print_errors_fp(stderr);
    }
}

/* ---------------------------------------------------------
   Create a TCP listening socket (no TLS handshake yet)
   --------------------------------------------------------- */
int tls_listen(int port) {
    int sock;
    struct sockaddr_in addr;

    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) return -1;

    memset(&addr, 0, sizeof(addr));
    addr.sin_family      = AF_INET;
    addr.sin_port        = htons(port);
    addr.sin_addr.s_addr = INADDR_ANY;

    if (bind(sock, (struct sockaddr*)&addr, sizeof(addr)) < 0)
        return -2;

    if (listen(sock, 5) < 0)
        return -3;

    return sock;
}

/* ---------------------------------------------------------
   Accept a TCP client (no TLS handshake yet)
   --------------------------------------------------------- */
int tls_accept(int server) {
    int client = accept(server, NULL, NULL);
    if (client < 0) return -1;
    return client;
}

/* ---------------------------------------------------------
   Connect to a remote TCP server (no TLS handshake yet)
   --------------------------------------------------------- */
int tls_connect(const char *host, int port) {
    int sock;
    struct sockaddr_in addr;

    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) return -1;

    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port   = htons(port);

    if (inet_pton(AF_INET, host, &addr.sin_addr) <= 0)
        return -2;

    if (connect(sock, (struct sockaddr*)&addr, sizeof(addr)) < 0)
        return -3;

    return sock;
}

/* ---------------------------------------------------------
   Send raw bytes over TCP
   --------------------------------------------------------- */
int tls_send(int sock, const char *buf, int len) {
    return send(sock, buf, len, 0);
}

/* ---------------------------------------------------------
   Receive raw bytes over TCP
   --------------------------------------------------------- */
int tls_recv(int sock, char *buf, int maxlen) {
    return recv(sock, buf, maxlen, 0);
}

/* ---------------------------------------------------------
   Close socket
   --------------------------------------------------------- */
void tls_close(int sock) {
    close(sock);
}
