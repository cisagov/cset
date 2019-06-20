(function () {
    Sidebar.prototype.addCSETPalettes = function () {


        // perimeter=ellipsePerimeter or rectangle (and there are others).  
        // Probably use rectangle for most, except circular images.  
        var d = 50;
        var dt = 'ibm';
        var sb = this;
        var s = 'aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/';

        var gn = 'ms active directory ';



        var fns = [
            this.createVertexTemplateEntry(s + 'configuration_server.svg;',
                d, d, '', 'Configuration Server', false, null, this.getTagsForStencil(gn, 'configuration server', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'dcs.svg;',
                d, d, '', 'DCS', false, null, this.getTagsForStencil(gn, 'dcs', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'ews.svg;',
                d, d, '', 'EWS', false, null, this.getTagsForStencil(gn, 'ews', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'front_end_processor.svg;',
                d, d, '', 'FEP', false, null, this.getTagsForStencil(gn, 'fep', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'historian.svg;',
                d, d, '', 'Historian', false, null, this.getTagsForStencil(gn, 'historian', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'hmi.svg;',
                d, d, '', 'HMI', false, null, this.getTagsForStencil(gn, 'hmi', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'ied.svg;',
                d, d, '', 'IED', false, null, this.getTagsForStencil(gn, 'ied', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'mtu.svg;',
                d, d, '', 'MTU', false, null, this.getTagsForStencil(gn, 'mtu', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'plc.svg;',
                d, d, '', 'PLC', false, null, this.getTagsForStencil(gn, 'plc', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'rtu.svg;',
                d, d, '', 'RTU', false, null, this.getTagsForStencil(gn, 'rtu', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'sis.svg;',
                d, d, '', 'SIS', false, null, this.getTagsForStencil(gn, 'sis', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'terminal_server.svg;',
                d, d, '', 'Terminal Server', false, null, this.getTagsForStencil(gn, 'terminal server', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'unidirectional_device.svg;',
                d, d, '', 'Unidirectional Device', false, null, this.getTagsForStencil(gn, 'unidirectional device', dt).join(' '))
        ];
        
        this.addPalette('ics', 'ICS', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns.length; i++) {
                content.appendChild(fns[i](content));
            }
        }));



        // All of these palette definitions should be refactored into their own functions
        

        var fns2 = [
            this.createVertexTemplateEntry(s + 'active_directory.svg;',
                d, d, '', 'Active Directory', false, null, this.getTagsForStencil(gn, 'Active Directory', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'application_server.svg;',
                d, d, '', 'Application Server', false, null, this.getTagsForStencil(gn, 'Application Server', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'building_automation_management_systems.svg;',
                d, d, '', 'BAS', false, null, this.getTagsForStencil(gn, 'BAS', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'clock.svg;',
                d, d, '', 'Clock', false, null, this.getTagsForStencil(gn, 'Clock', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'database_server.svg;',
                d, d, '', 'DB Server', false, null, this.getTagsForStencil(gn, 'DB Server', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'dns_server.svg;',
                d, d, '', 'DNS', false, null, this.getTagsForStencil(gn, 'DNS', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'door_access_door_control.svg;',
                d, d, '', 'Door Control Unit', false, null, this.getTagsForStencil(gn, 'Door Control Unit', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'electronic_security_system.svg;',
                d, d, '', 'ESS', false, null, this.getTagsForStencil(gn, 'ESS', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'firewall.svg;',
                d, d, '', 'Firewall', false, null, this.getTagsForStencil(gn, 'Firewall', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'handheld_wireless_device.svg;',
                d, d, '', 'Handheld Wireless Device', false, null, this.getTagsForStencil(gn, 'Handheld Wireless Device', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'hub.svg;',
                d, d, '', 'Hub', false, null, this.getTagsForStencil(gn, 'Hub', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'ids.svg;',
                d, d, '', 'IDS', false, null, this.getTagsForStencil(gn, 'IDS', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'ip_camera.svg;',
                d, d, '', 'IP Camera', false, null, this.getTagsForStencil(gn, 'IP Camera', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'ip_phone.svg;',
                d, d, '', 'IP Phone', false, null, this.getTagsForStencil(gn, 'IP Phone', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'ips.svg;',
                d, d, '', 'IPS', false, null, this.getTagsForStencil(gn, 'IPS', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'interactive_television_system.svg;',
                d, d, '', 'ITV', false, null, this.getTagsForStencil(gn, 'ITV', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'public_kiosk.svg;',
                d, d, '', 'Kiosk', false, null, this.getTagsForStencil(gn, 'Kiosk', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'link_encryption.svg;',
                d, d, '', 'Link Encryption', false, null, this.getTagsForStencil(gn, 'Link Encryption', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'mail_server.svg;',
                d, d, '', 'Mail Server', false, null, this.getTagsForStencil(gn, 'Mail Server', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'modem.svg;',
                d, d, '', 'Modem', false, null, this.getTagsForStencil(gn, 'Modem', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'multi_protocol_label_switching.svg;',
                d, d, '', 'MPLS', false, null, this.getTagsForStencil(gn, 'MPLS', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'multiple_services_component.svg;',
                d, d, '', 'Multiple Services Component', false, null, this.getTagsForStencil(gn, '?', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'network_printer.svg;',
                d, d, '', 'Network Printer', false, null, this.getTagsForStencil(gn, 'Network Printer', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'network_scanner_and_copier.svg;',
                d, d, '', 'NSC', false, null, this.getTagsForStencil(gn, 'NSC', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'optical_ring.svg;',
                d, d, '', 'Optical Ring', false, null, this.getTagsForStencil(gn, 'Optical Ring', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'pc.svg;',
                d, d, '', 'PC', false, null, this.getTagsForStencil(gn, 'PC', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'power_over_ethernet.svg;',
                d, d, '', 'Power Over Ethernet', false, null, this.getTagsForStencil(gn, 'Power Over Ethernet', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'remote_access_server.svg;',
                d, d, '', 'RAS', false, null, this.getTagsForStencil(gn, 'RAS', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'rfid_transmitter.svg;',
                d, d, '', 'RFID', false, null, this.getTagsForStencil(gn, 'RFID', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'router.svg;',
                d, d, '', 'Router', false, null, this.getTagsForStencil(gn, 'Router', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'serial_radio.svg;',
                d, d, '', 'Serial Radio', false, null, this.getTagsForStencil(gn, 'Serial Radio', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'serial_switch.svg;',
                d, d, '', 'Serial Switch', false, null, this.getTagsForStencil(gn, 'Serial Switch', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'server.svg;',
                d, d, '', 'Server', false, null, this.getTagsForStencil(gn, 'Server', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'security_information_and_event_management_system.svg;',
                d, d, '', 'SIEMS', false, null, this.getTagsForStencil(gn, 'SIEMS', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'switch.svg;',
                d, d, '', 'Switch', false, null, this.getTagsForStencil(gn, 'Switch', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'uninterruptible_power_supply.svg;',
                d, d, '', 'UPS', false, null, this.getTagsForStencil(gn, 'UPS', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'virtual_machine_server.svg;',
                d, d, '', 'Virtual Machine Server', false, null, this.getTagsForStencil(gn, 'Virtual Machine Server', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'vlan_router.svg;',
                d, d, '', 'VLAN Router', false, null, this.getTagsForStencil(gn, 'VLAN Router', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'vlan_switch.svg;',
                d, d, '', 'VLAN Switch', false, null, this.getTagsForStencil(gn, 'VLAN Switch', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'vpn.svg;',
                d, d, '', 'VPN', false, null, this.getTagsForStencil(gn, 'VPN', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'video_teleconferencing_equipment.svg;',
                d, d, '', 'VTC', false, null, this.getTagsForStencil(gn, 'VTC', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'web_server.svg;',
                d, d, '', 'Web Server', false, null, this.getTagsForStencil(gn, 'Web Server', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'windows_update_server.svg;',
                d, d, '', 'Windows Update Server', false, null, this.getTagsForStencil(gn, 'Windows Update Server', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'wireless_modem.svg;',
                d, d, '', 'Wireless Modem', false, null, this.getTagsForStencil(gn, 'Wireless Modem', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'wireless_network.svg;',
                d, d, '', 'Wireless Network', false, null, this.getTagsForStencil(gn, 'Wireless Network', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'wireless_router.svg;',
                d, d, '', 'Wireless Router', false, null, this.getTagsForStencil(gn, 'wireless router', dt).join(' '))
        ];

        this.addPalette('it', 'IT', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns2.length; i++) {
                content.appendChild(fns2[i](content));
            }
        }));



        var fns3 = [
            this.createVertexTemplateEntry(s + 'audio_switch.svg;',
                d, d, '', 'Audio Switch', false, null, this.getTagsForStencil(gn, 'Audio Switch', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'dispatch_console.svg;',
                d, d, '', 'Dispatch Console', false, null, this.getTagsForStencil(gn, 'Dispatch Console', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'ethernet_backhaul.svg;',
                d, d, '', 'Ethernet Backhaul', false, null, this.getTagsForStencil(gn, 'Ethernet Backhaul', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'master_site.svg;',
                d, d, '', 'Master Site', false, null, this.getTagsForStencil(gn, 'Master Site', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'microwave_backhaul.svg;',
                d, d, '', 'Microwave Backhaul', false, null, this.getTagsForStencil(gn, 'Microwave Backhaul', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'radio_site.svg;',
                d, d, '', 'Radio Site', false, null, this.getTagsForStencil(gn, 'Radio Site', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'relay_panel.svg;',
                d, d, '', 'Relay Panel', false, null, this.getTagsForStencil(gn, 'Relay Panel', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'subscriber_radio.svg;',
                d, d, '', 'Subscriber Radio', false, null, this.getTagsForStencil(gn, 'Subscriber Radio', dt).join(' ')),
            this.createVertexTemplateEntry(s + 't1_backhaul.svg;',
                d, d, '', 'T1 Backhaul', false, null, this.getTagsForStencil(gn, 'T1 Backhaul', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'tdm_backhaul.svg;',
                d, d, '', 'TDM Backhaul', false, null, this.getTagsForStencil(gn, 'TDM Backhaul', dt).join(' '))
        ];

        this.addPalette('radio', 'Radio', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns3.length; i++) {
                content.appendChild(fns3[i](content));
            }
        }));



        this.addPalette('medical', 'Medical', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns.length; i++) {
                content.appendChild(fns[i](content));
            }
        }));

        this.addPalette('general', 'General', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns.length; i++) {
                content.appendChild(fns[i](content));
            }
        }));

        this.addPalette('zone', 'Zone', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns.length; i++) {
                content.appendChild(fns[i](content));
            }
        }));

        this.addPalette('shapes', 'Shapes', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns.length; i++) {
                content.appendChild(fns[i](content));
            }
        }));
    };





})();
