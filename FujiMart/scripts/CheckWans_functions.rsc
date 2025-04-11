:global installCheckWANsInfo do {
    #$installCheckWANsInfo CustomerName="FujiMart VietNam" CustomerBranchLocation="FJM ToHuu"
    :if ([:typeof $CustomerName] = "nothing") do={:error "Customer Name missing"};
    :if ([:typeof $CustomerBranchLocation] = "nothing") do={:error "Customer Branch Location missing"};
    /system script remove [find name=CheckWans_config_base]
    /system script add name=CheckWans_config_base owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive source=":global CustomerName \"$CustomerName\"\
        :global CustomerBranchLocation \"$CustomerBranchLocation\""
}

