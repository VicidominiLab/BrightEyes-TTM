### I/Os

# EXTRA PIN
set_property -dict {PACKAGE_PIN H25 IOSTANDARD LVCMOS25} [get_ports CONN_J40]
set_property -dict {PACKAGE_PIN G28 IOSTANDARD LVCMOS25} [get_ports CONN_J15]
set_property -dict {PACKAGE_PIN F28 IOSTANDARD LVCMOS25} [get_ports CONN_J4]
set_property -dict {PACKAGE_PIN C29 IOSTANDARD LVCMOS25} [get_ports CONN_J14]
set_property -dict {PACKAGE_PIN B29 IOSTANDARD LVCMOS25} [get_ports CONN_J3]
set_property -dict {PACKAGE_PIN B27 IOSTANDARD LVCMOS25} [get_ports CONN_J18]
set_property -dict {PACKAGE_PIN A27 IOSTANDARD LVCMOS25} [get_ports CONN_J38]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS25} [get_ports CONN_J12]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS25} [get_ports CONN_J17]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS25} [get_ports CONN_J1	]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS25} [get_ports CONN_J6	]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS25} [get_ports CONN_J21]
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS25} [get_ports CONN_J26]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS25} [get_ports CONN_J31]
set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVCMOS25} [get_ports CONN_J36]


		     
		     
	      
	      
		     
		     
		     
		     
              


set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets photon_channels*]

# J2 ON FLIM
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS25} [get_ports {photon_channels[0]}]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS25} [get_ports {photon_channels[1]}]
set_property -dict {PACKAGE_PIN H30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[2]}]
set_property -dict {PACKAGE_PIN G30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[3]}]
set_property -dict {PACKAGE_PIN D29 IOSTANDARD LVCMOS25} [get_ports {photon_channels[4]}]

set_property -dict {PACKAGE_PIN C30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[5]}]
set_property -dict {PACKAGE_PIN B28 IOSTANDARD LVCMOS25} [get_ports {photon_channels[6]}]
set_property -dict {PACKAGE_PIN A28 IOSTANDARD LVCMOS25} [get_ports {photon_channels[7]}]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS25} [get_ports {photon_channels[8]}]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS25} [get_ports {photon_channels[9]}]

set_property -dict {PACKAGE_PIN G29 IOSTANDARD LVCMOS25} [get_ports {photon_channels[10]}]
set_property -dict {PACKAGE_PIN F30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[11]}]
set_property -dict {PACKAGE_PIN B30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[12]}]
set_property -dict {PACKAGE_PIN A30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[13]}]
set_property -dict {PACKAGE_PIN A25 IOSTANDARD LVCMOS25} [get_ports {photon_channels[14]}]

set_property -dict {PACKAGE_PIN A26 IOSTANDARD LVCMOS25} [get_ports {photon_channels[15]}]
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS25} [get_ports {photon_channels[16]}]
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVCMOS25} [get_ports {photon_channels[17]}]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS25} [get_ports {photon_channels[18]}]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS25} [get_ports {photon_channels[19]}]

set_property -dict {PACKAGE_PIN H26 IOSTANDARD LVCMOS25} [get_ports {photon_channels[20]}]

set_property -dict {PACKAGE_PIN H27 IOSTANDARD LVCMOS25} [get_ports {photon_channels[21]}]
set_property -dict {PACKAGE_PIN E29 IOSTANDARD LVCMOS25} [get_ports {photon_channels[22]}]
set_property -dict {PACKAGE_PIN E30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[23]}]
set_property -dict {PACKAGE_PIN H24 IOSTANDARD LVCMOS25} [get_ports {photon_channels[24]}]
