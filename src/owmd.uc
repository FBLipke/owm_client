import { cursor } from 'uci';
import * as fs from 'fs';

let ctx = cursor();

let api_server = "openwifi.net";
let port = 443;
let interval = 60;

function Send_http_request(server, hostname, content) {
    let MSG="\
PUT /update_node/" + hostname + ".olsr HTTP/1.1\r
User-Agent: nc/0.0.1\r
Host: " + server + "\r
Content-type: application/json\r
Content-length: $LEN\r
\r";

    print(MSG);
}

function owmd_create_default_config() {
    ctx.set("owmd", "general", "interval", "600");
    ctx.set("owmd", "general", "server", "owm.server.org");
    ctx.set("owmd", "general", "port", "80");
    ctx.commit();
    ctx.save();

    print(ctx.error(), "\n");
}

function main() {
    if (!fs.access("/etc/config/owmd","f"))
    {
        owmd_create_default_config();

        print("[i] created default config for owm!\n");
    }
        
    if (!fs.access('/etc/config/freifunk', 'f'))
    {
        die("Error: /etc/config/freifunk not found!");
    }

	let myhostname = ctx.get_first('system', 'system', 'hostname');

    let ff_ct_ssid = ctx.get_first('freifunk', 'community', 'ssid');
    let ff_ct_meshnet = ctx.get_first('freifunk', 'community', 'mesh_network');
    let ff_ct_owmapi = ctx.get_first('freifunk', 'community', 'owm_api');

    let ff_ct_name = ctx.get_first('freifunk', 'community', 'name');
    let ff_ct_homepage = ctx.get_first('freifunk', 'community', 'homepage');
    let ff_ct_longitude = ctx.get_first('freifunk', 'community', 'longitude');
    let ff_ct_latitude = ctx.get_first('freifunk', 'community', 'latitude');

    let ff_ct_ssid_scheme = ctx.get_first('freifunk', 'community', 'ssid_scheme');
    let ff_ct_splash_network = ctx.get_first('freifunk', 'community', 'splash_network');
    let ff_ct_splash_prefix = ctx.get_first('freifunk', 'community', 'splash_prefix');

    Send_http_request(api_server, myhostname, "");
}

main();