program tls_client
    use iso_c_binding
    use tls_module
    implicit none

    integer(c_int) :: handle, n
    character(kind=c_char), dimension(1024) :: buffer
    character(kind=c_char), dimension(32)  :: host
    character(kind=c_char), dimension(256) :: request


    ! Initialize arrays
    host = c_null_char
    request = c_null_char

    ! Fill host C-string manually
    host(1:14) = (/ '9','3','.','1','8','4','.','2','1','6','.','3','4', c_null_char /)

    ! Fill HTTP request manually
    request(1:38) = (/ &
        'G','E','T',' ','/',' ','H','T','T','P','/','1','.','1', char(13), char(10), &
        'H','o','s','t',':',' ','e','x','a','m','p','l','e','.','c','o','m', char(13), char(10), &
        char(13), char(10), c_null_char /)

    call tls_init()

    handle = tls_connect(host, 443)
    if (handle < 0) then
        print *, "TLS connection failed"
        stop
    end if

    n = tls_send(handle, request, 38)
    print *, "Sent bytes:", n

    n = tls_recv(handle, buffer, 1024)
    print *, "Received bytes:", n

    call tls_close(handle)
end program tls_client
