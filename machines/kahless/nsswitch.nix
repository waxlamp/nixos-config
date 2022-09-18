{ ... }:

{
  environment.etc."nsswitch.conf".text = ''
    passwd:    files mymachines systemd
    group:     files mymachines systemd
    shadow:    files

    hosts:     files mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns mdns myhostname
    networks:  files

    ethers:    files
    services:  files
    protocols: files
    rpc:       files
  '';
}
