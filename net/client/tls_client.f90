program tls_client
    use iso_c_binding
    use tls_module
    implicit none

    integer(c_int) :: sock, nbytes
    character(kind=c_char), dimension(:), allocatable :: host, request
    character(kind=c_char), dimension(4096) :: buffer

    character(len=*), parameter :: host_str = "127.0.0.1"
    character(len=*), parameter :: req_str = &
        "GET / HTTP/1.1" // char(13) // char(10) // &
        "Host: example.com" // char(13) // char(10) // &
        char(13) // char(10)

    integer :: i

    ! Build proper C-strings
    host    = [(host_str(i:i), i=1,len_trim(host_str)), c_null_char]
    request = [(req_str(i:i),  i=1,len_trim(req_str)),  c_null_char]

    print *, "Connecting to server..."

    call tls_init_f()

    ! CONNECT
    sock = tls_connect_f(host, 4433)
    if (sock < 0) then
        print *, "ERROR: tls_connect_f failed, code=", sock
        stop
    endif

    print *, "Connected."

    ! SEND
    call tls_send_f(sock, request, len_trim(req_str))
    print *, "Request sent."

    ! RECEIVE
    nbytes = tls_recv_f(sock, buffer, size(buffer))
    if (nbytes > 0) then
        print *, "Received ", nbytes, " bytes:"
        print *, transfer(buffer(1:nbytes), "")
    else
        print *, "No data received."
    endif

    call tls_close_f(sock)
    print *, "Connection closed."

end program tls_client
