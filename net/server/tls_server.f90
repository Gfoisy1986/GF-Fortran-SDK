program tls_server
    use iso_c_binding
    use tls
    use tcp
    use router
    implicit none

    integer(c_int) :: sock, client, tls_handle, n
    character(kind=c_char), dimension(2048) :: buffer

    call tls_init()

    print *, "Starting TLS server on port 8443..."

    sock = tcp_listen(8443)

    do
        client = tcp_accept(sock)
        if (client < 0) cycle

        tls_handle = tls_accept(client)
        if (tls_handle < 0) cycle

        n = tls_recv(tls_handle, buffer, 2048)

        if (n > 0) then
            call route_message(transfer(buffer, ""))
        end if

        call tls_close(tls_handle)
    end do

end program tls_server
