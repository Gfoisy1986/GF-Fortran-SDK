module tls_module
    use iso_c_binding
    implicit none

    private
    public :: tls_init_f, tls_listen_f, tls_accept_f, tls_connect_f
    public :: tls_send_f, tls_recv_f, tls_close_f

    interface
        subroutine tls_init() bind(C, name="tls_init")
            use iso_c_binding
        end subroutine tls_init

        function tls_listen(port) bind(C, name="tls_listen")
            use iso_c_binding
            integer(c_int) :: tls_listen
            integer(c_int), value :: port
        end function tls_listen

        function tls_accept(server) bind(C, name="tls_accept")
            use iso_c_binding
            integer(c_int) :: tls_accept
            integer(c_int), value :: server
        end function tls_accept

        function tls_connect(host, port) bind(C, name="tls_connect")
            use iso_c_binding
            integer(c_int) :: tls_connect
            character(kind=c_char), dimension(*) :: host
            integer(c_int), value :: port
        end function tls_connect

        function tls_send(sock, buf, len) bind(C, name="tls_send")
            use iso_c_binding
            integer(c_int) :: tls_send
            integer(c_int), value :: sock
            character(kind=c_char), dimension(*) :: buf
            integer(c_int), value :: len
        end function tls_send

        function tls_recv(sock, buf, maxlen) bind(C, name="tls_recv")
            use iso_c_binding
            integer(c_int) :: tls_recv
            integer(c_int), value :: sock
            character(kind=c_char), dimension(*) :: buf
            integer(c_int), value :: maxlen
        end function tls_recv

        subroutine tls_close(sock) bind(C, name="tls_close")
            use iso_c_binding
            integer(c_int), value :: sock
        end subroutine tls_close
    end interface

contains

    subroutine tls_init_f()
        call tls_init()
    end subroutine tls_init_f

    function tls_listen_f(port) result(server)
        integer(c_int), value :: port
        integer(c_int)        :: server
        server = tls_listen(port)
    end function tls_listen_f

    function tls_accept_f(server_in) result(client)
        integer(c_int), value :: server_in
        integer(c_int)        :: client
        client = tls_accept(server_in)
    end function tls_accept_f

    function tls_connect_f(host, port) result(sock)
        character(kind=c_char), dimension(*) :: host
        integer(c_int), value                :: port
        integer(c_int)                       :: sock
        sock = tls_connect(host, port)
    end function tls_connect_f

    subroutine tls_send_f(sock, buf, len)
        use iso_c_binding
        integer(c_int), value                :: sock
        character(kind=c_char), dimension(*) :: buf
        integer(c_int), value                :: len
        integer(c_int)                       :: nsent

        nsent = tls_send(sock, buf, len)
        ! you can optionally check nsent here
    end subroutine tls_send_f

    function tls_recv_f(sock, buf, maxlen) result(nrecv)
        integer(c_int), value                :: sock
        character(kind=c_char), dimension(*) :: buf
        integer(c_int), value                :: maxlen
        integer(c_int)                       :: nrecv
        nrecv = tls_recv(sock, buf, maxlen)
    end function tls_recv_f

    subroutine tls_close_f(sock)
        integer(c_int), value :: sock
        call tls_close(sock)
    end subroutine tls_close_f

end module tls_module
