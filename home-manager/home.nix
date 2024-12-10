{ system, ... }:
{
 imports = if system == "aarch64-darwin"
                then [ ./nixos ]
                # then [ ./darwin ]
                # else [ ./nixos ];
                else [ ./darwin ];

}
