#include <openssl/ssl.h>
#include <openssl/err.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

static SSL_CTX *ctx = NULL;

void tls_init()
{
    SSL_library_init();
    SSL_load_error_strings();
    OpenSSL_add_all_algorithms();
    ctx = SSL_CTX_new(TLS_client_method());
}

int tls_connect(const char *host, int port)
{
    int sock = socket(AF_INET, SOCK_STREAM, 0);

    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    inet_pton(AF_INET, host, &addr.sin_addr);

    if (connect(sock, (struct sockaddr*)&addr, sizeof(addr)) != 0)
        return -1;

    SSL *ssl = SSL_new(ctx);
    SSL_set_fd(ssl, sock);

    if (SSL_connect(ssl) <= 0)
        return -2;

    return (int)(intptr_t)ssl;
}

int tls_accept(int client_sock)
{
    SSL *ssl = SSL_new(ctx);
    SSL_set_fd(ssl, client_sock);

    if (SSL_accept(ssl) <= 0)
        return -1;

    return (int)(intptr_t)ssl;
}

int tls_send(int ssl_handle, const void *buf, int len)
{
    SSL *ssl = (SSL*)(intptr_t)ssl_handle;
    return SSL_write(ssl, buf, len);
}

int tls_recv(int ssl_handle, void *buf, int maxlen)
{
    SSL *ssl = (SSL*)(intptr_t)ssl_handle;
    return SSL_read(ssl, buf, maxlen);
}

void tls_close(int ssl_handle)
{
    SSL *ssl = (SSL*)(intptr_t)ssl_handle;
    int sock = SSL_get_fd(ssl);
    SSL_shutdown(ssl);
    SSL_free(ssl);
    close(sock);
}
