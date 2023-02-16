#!/bin/bash

#  Storyline: Menu for admin, VPN, and Security functions
function invalid_opt()  {

        echo ""
        echo "Invalid option!"
        echo ""
        sleep 2
        
      
}
function menu() {

         # clears the screen
         clear

         echo "[1] Admin Menu"
         echo "[2] Security Menu"
         echo "[3] Exit"                                                                                                                    menu.bash                                                                                                                          I   S  
         read -p "Please enter a choice above: " choice
 
         case "$choice" in
 
                 1) admin_menu
                 ;;
 
                 2) security_menu
                 ;;
 
                 3) exit 0
                 ;;
 
                 *)
                        invalid_opt
                        # Call the main menu
                        menu
                 ;;
 
          esac
 
 
}
function admin_menu()  {

        clear
        echo "[L]ist Running Processes"
        echo "[N]etwork sockets"
        echo "[V]PN Menu"
        echo "[4] Exit"
        read -p "Please enter a choice above: " choice

        case "$choice" in
 
                L|l)
                        ps -ef | less
                ;;
                  
                N|n)
                        netstat -an --inet | less
                ;;

                V|v)
                         vpn_menu
                ;;
 
                4) exit 0
 
                ;;                                                                                                                      menu.bash                                                                                                                          I   S  
                
 
                *)
                        invalid_opt

                        admin_menu
                ;;
 
 
    esac
 
 
admin_menu
}
 
function security_menu(){
        clear
        echo "[1] list open sockets"
        echo "[2] Check users with UID of 0"
        echo "[3] Check last 10 logged in users"
        echo "[4] Current logged in users"
        echo "[5] Main Menu"
        echo "[6] Exit"
        read -p "Please enter a choice above: * choice
 
        case "$choice" in 
                1) netstat -an --inet | less
                        ;;
                2) cat /etc/passwd | grep 0:0 | less
                        ;;
                3) last | less
                        ;;
                4) w | less
                        ;;
                5) menu
                        ;;
                6) exit 0
                        ;;
                 *)
                        invalid_opt

                        ;;
    esac



security_menu                                                                                                                       menu.bash                                                                                                                          I   S  
}
function vpn_menu() {
        clear
        echo "[A]dd a peer"
        echo "[D]elete a peer"
        echo "[B]ack to admin menu"
        echo "[M]ain Menu"
        echo "[E]xit"
        read -p "Please select an option: " choice
        
        case "$choice" in
                A|a) bash peer.bash
                 tail -6 wg0.conf | less
                        ;;
                D|d) echo "Please enter a user you would like to delete..."
                        read {deluser}
                        bash manage-users.bash -d -u ${deluser}
                        ;;
                B|b) admin_menu
                        ;;
                M|m) menu
                        ;;
                E|e) exit 0
                        ;;
                *)
                         invalid_opt

                        ;;
    esac



vpn_menu
}

# Call the main function
menu
