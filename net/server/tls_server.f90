program tls_server
    use iso_c_binding
    use tls_module
    implicit none

    integer(c_int) :: server, client, nbytes
    character(kind=c_char), dimension(4096) :: buffer

    print *, "Starting TLS server on port 4433..."

    ! Initialize TLS library (OpenSSL init)
    call tls_init_f()

    ! Create listening TCP socket
    server = tls_listen_f(4433)
    if (server < 0) then
        print *, "ERROR: tls_listen_f failed, code=", server
        stop
    endif

    print *, "Server listening. Waiting for client..."

    ! Accept client
    client = tls_accept_f(server)
    if (client < 0) then
        print *, "ERROR: tls_accept_f failed, code=", client
        call tls_close_f(server)
        stop
    endif

    print *, "Client connected."

    ! Receive data
    nbytes = tls_recv_f(client, buffer, size(buffer))
    if (nbytes > 0) then
        print *, "Received ", nbytes, " bytes:"
        print *, transfer(buffer(1:nbytes), "")
    else
        print *, "No data received or recv error."
    endif

    ! Send response
    call tls_send_f(client, &
        "Hello from TLS server" // c_null_char, &
        len("Hello from TLS server"))

    print *, "Response sent. Closing connection."

    ! Close client + server sockets
    call tls_close_f(client)
    call tls_close_f(server)

    print *, "TLS server closed."

end program tls_server
