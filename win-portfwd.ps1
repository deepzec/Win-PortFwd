$text = @"
 _    _ _            ______          _  ______           _ 
| |  | (_)           | ___ \        | | |  ___|         | |
| |  | |_ _ __ ______| |_/ /__  _ __| |_| |___      ____| |
| |/\| | | '_ \______|  __/ _ \| '__| __|  _\ \ /\ / / _` |
\  /\  / | | | |     | | | (_) | |  | |_| |  \ V  V / (_| |
 \/  \/|_|_| |_|     \_|  \___/|_|   \__\_|   \_/\_/ \__,_|
                                                          
Author : DeepZec																							
"@
write-host -fore green $text
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}
do {
    do {
		write-host ""
        write-host "A - Setup a port forwarding"
        write-host "B - Show current fowarding list"
        write-host "C - Remove all forwarding"
        write-host ""
        write-host "X - Exit"
        write-host ""
        write-host -nonewline "Type your choice and press Enter: "
        
        $choice = read-host
        
        write-host ""
        
        $ok = $choice -match '^[abcdx]+$'
        
        if ( -not $ok) { write-host "Invalid selection" }
    } until ( $ok )
    
    switch -Regex ( $choice ) {
        "A"
        {
			do {
			$Lhost = Read-Host -Prompt 'Enter local machine address'
			$ok = $Lhost -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"
			if ( -not $ok) { write-host "Invalid host address" }
				} until ( $ok )
				
			do {
            $Lport = Read-Host -Prompt 'Enter local port to listen'
			$ok = [int]$Lport -le 65535
			if ( -not $ok) { write-host "Invalid Port Number" }
				} until ( $ok )
			
			do {
			$Rhost = Read-Host -Prompt 'Enter Remote server address'
			$ok = $Lhost -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"
			if ( -not $ok) { write-host "Invalid host address" }
				} until ( $ok )
			
			do {
			$Rport = Read-Host -Prompt 'Enter Remote port'
			$ok = [int]$Lport -le 65535 
			if ( -not $ok) { write-host "Invalid Port Number" }
				} until ( $ok )
				
			if ( -not $ok) { write-host "Invalid user input" }
			
			else {
			netsh interface portproxy add v4tov4 listenaddress=$Lhost listenport=$Lport connectaddress=$Rhost connectport=$Rport
			netsh interface portproxy show all
				}
        }
        
        "B"
        {
            netsh interface portproxy show all
        }

        "C"
        {
            netsh interface portproxy reset
        }


    }
} until ( $choice -match "X" )

