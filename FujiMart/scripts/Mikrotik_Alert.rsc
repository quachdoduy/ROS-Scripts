# =============== HEADER ===============
# RouterOS script: FunctionLibrary
# Copyright (c) 2024-2025 
#  Author: Quach Do Duy 
#  Email: <quachdoduy@gmail.com>
#  Git URL: /quachdoduy/Mikrotik-RouterOS-Script
# --------------------------------------
# Please, keep this header if using this script.
# ============= END HEADER =============

# Declare variables for client customization.
:global CustomerName "FujiMart VietNam"
:global CustomerBranchLocation "FJM ToHuu"

# Declare variables for Telegram.
# :global TelegramAPIToken [/file get [find name="telegram.info.txt"] contents]
:global TelegramAPIToken "7048815678:AAFF_S1FdkabzvF3tD4ZlSvX9UNiAgDWjLQ"
:global TelegramChatID "2193311615"
:global TelegramChatTypeGroup true
:if ($TelegramChatTypeGroup) do={
    :set TelegramChatID ("-100" . $TelegramChatID)
}
:global TelegramFullURL ("https://api.telegram.org/bot" . $TelegramAPIToken . "/sendMessage?chat_id=" . $TelegramChatID)
:global TelegramMessage ""
:global TelegramSend false

# Declare variables for system.
:global InactiveWanList [:toarray ""]
:global ActiveWanList [:toarray ""]
:global DisabledWanList [:toarray ""]
:global TimeNow [/system clock get time]
:global DateNow [/system clock get date]

# Declare Ping target for testing active WAN interfaces
:local PingTarget 8.8.8.8

# Loop through all PPPoE clients
:foreach i in=[/interface pppoe-client find] do={
	
	:local pppoeName [/interface get $i name]
	:local isDisabled [/interface get $i disabled]
	:local isRunning [/interface get $i running]

	# If interface is disabled, add to DisabledWanList
	:if ($isDisabled = true) do={
		:set DisabledWanList ($DisabledWanList, $pppoeName)
	} else={
		# If interface is enabled but not running, add to InactiveWanList
		:if ($isRunning = false) do={
			:set InactiveWanList ($InactiveWanList, $pppoeName)
		} else={
			# Ping test to see if the WAN is really active
			:local PingResult [ping $PingTarget count=5 interface=$pppoeName]
			:if ($PingResult = 0) do={
				:set InactiveWanList ($InactiveWanList, $pppoeName)
			} else={
				:set ActiveWanList ($ActiveWanList, $pppoeName)
			}
		}
	}
}

# Log the contents of the lists for debugging
:log warning ("Disabled interfaces: " . $DisabledWanList)
:log warning ("Inactive interfaces: " . $InactiveWanList)

#Prepare Telegram message
:set TelegramMessage ($CustomerName . " - " . $CustomerBranchLocation . " - " . $DateNow . " " . $TimeNow . ":")

# Prepare Telegram message for Disabled interfaces
:if ([:len $DisabledWanList] > 0 ) do={
	:local list ""
	:foreach i in=$DisabledWanList do={
		:set list ($list . "%0A- " . $i)
	}
	:set TelegramMessage ($TelegramMessage . "%0AWANs Disabled: " . $list)
	:set TelegramSend true
}

# Prepare Telegram message for Inactive interfaces
:if ([:len $InactiveWanList] > 0) do={
	:local list ""
	:foreach i in=$InactiveWanList do={
		:set list ($list . "%0A- " . $i)
	}
	:set TelegramMessage ($TelegramMessage . "%0AWANs Inactive: " . $list)
	:set TelegramSend true
}

# Process send warning to Telegram
:if ($TelegramSend) do {
	:set TelegramFullURL ($TelegramFullURL . "&text=" . $TelegramMessage)
	tool fetch url=$TelegramFullURL
	#:log info ("Telegram Send: " . $TelegramMessage)
}

# Reset lists after checking
:set TelegramMessage ""
:set TelegramSend false
:set InactiveWanList [:toarray ""]
:set ActiveWanList [:toarray ""]
:set DisabledWanList [:toarray ""]