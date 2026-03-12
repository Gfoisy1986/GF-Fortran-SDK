module router
    implicit none

contains

    subroutine route_message(msg)
        character(len=*), intent(in) :: msg

        if (index(msg, "PING") > 0) then
            print *, "Received PING"
        else
            print *, "Unknown command:", trim(msg)
        end if
    end subroutine

end module router
