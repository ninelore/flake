#!/usr/bin/env python3

'''
Derived from https://github.com/WeirdTreeThing/cros-keyboard-map

----------------------------------------------------------------

BSD 3-Clause License

Copyright (c) 2023, WeirdTreeThing

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'''

import argparse
import platform

device_ids = {
    "k:0000:0000", # cros_ec keyboard
    "k:0001:0001", # AT keyboard
    "k:18d1:503c", # Google Inc. Hammer
    "k:18d1:5050", # Google Inc. Hammer
    "k:18d1:504c", # Google Inc. Hammer
    "k:18d1:5052", # Google Inc. Hammer
    "k:18d1:5057", # Google Inc. Hammer
    "k:18d1:505b", # Google Inc. Hammer
    "k:18d1:5030", # Google Inc. Hammer
    "k:18d1:503d", # Google Inc. Hammer
    "k:18d1:5044", # Google Inc. Hammer
    "k:18d1:5061", # Google Inc. Hammer
    "k:18d1:502b", # Google Inc. Hammer
}

vivaldi_keys = {
    "x86_64": {
        "90": "previoussong",
        "91": "zoom",
        "92": "scale",
        "93": "print",
        "94": "brightnessdown",
        "95": "brightnessup",
        "97": "kbdillumdown",
        "98": "kbdillumup",
        "99": "nextsong",
        "9A": "playpause",
        "9B": "micmute",
        "9E": "kbdillumtoggle",
        "A0": "mute",
        "AE": "volumedown",
        "B0": "volumeup",
        "E9": "forward",
        "EA": "back",
        "E7": "refresh",
    },
    "arm": {
        "158": "back",
        "159": "forward",
        "173": "refresh",
        "372": "zoom",
        "120": "scale",
        "224": "brightnessdown",
        "225": "brightnessup",
        "113": "mute",
        "114": "volumedown",
        "115": "volumeup",
        "99" : "print",
    }
}

def get_arch():
    return platform.uname().machine

def get_ids_string(device_ids):
    return "\n".join(device_ids)

def get_dt_layout():
    keys = []
    keycodes = []

    fdt = libfdt.Fdt(open("/sys/firmware/fdt", "rb").read())
    currentnode = fdt.first_subnode(0)

    while True:
        try:
            if fdt.get_name(currentnode) == "keyboard-controller":
                prop = fdt.getprop(currentnode, "linux,keymap")
                keys = prop.as_uint32_list()
            currentnode = fdt.next_node(currentnode, 10)[0]
        except:
            break

    if not keys:
        return ""

    for key in keys:
        keycode = str(key & 0xFFFF)
        if keycode in vivaldi_keys["arm"]:
            keycodes.append(keycode)
    return keycodes

def get_physmap_data():
    if get_arch() == "x86_64":
        try:
            with open("/sys/bus/platform/devices/i8042/serio0/function_row_physmap", "r") as file:
                return file.read().strip().split()
        except FileNotFoundError:
            return ""
    else:
        return get_dt_layout()

def get_functional_row(physmap, use_vivaldi, super_is_held, super_inverted):
    arch = get_arch()
    if arch != "x86_64":
        arch = "arm"

    i = 0
    result = ""
    for code in physmap:
        i += 1
        # Map zoom to f11 since most applications wont listen to zoom
        mapping = "f11" if vivaldi_keys[arch][code] == "zoom" \
            else vivaldi_keys[arch][code]

        match [super_is_held, use_vivaldi, super_inverted]:
            case [True, True, False] | [False, True, True]:
                result += f"{vivaldi_keys[arch][code]} = f{i}\n"
            case [True, False, False] | [False, False, True]:
                result += f"f{i} = f{i}\n"
            case [False, True, False] | [True, True, True]:
                result += f"{vivaldi_keys[arch][code]} = {mapping}\n"
            case [False, False, False] | [True, False, True]:
                result += f"f{i} = {mapping}\n"

    return result

def get_keyd_config(physmap, inverted):
    config = f"""\
[ids]
{get_ids_string(device_ids)}

[main]
{get_functional_row(physmap, use_vivaldi=False, super_is_held=False, super_inverted=inverted)}
{get_functional_row(physmap, use_vivaldi=True, super_is_held=False, super_inverted=inverted)}
f13 = coffee
sleep = coffee

[meta]
{get_functional_row(physmap, use_vivaldi=False, super_is_held=True, super_inverted=inverted)}
{get_functional_row(physmap, use_vivaldi=True, super_is_held=True, super_inverted=inverted)}
f13 = f12
sleep = f12
coffee = f12

[alt]
backspace = delete
brightnessdown = kbdillumdown
brightnessup = kbdillumup
f6 = kbdillumdown
f7 = kbdillumup

[control]
f5 = print
scale = print

[altgr]
left = home
right = end
up = pageup
down = pagedown

[control+alt]
backspace = C-A-delete
"""
    return config

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "--file", default="cros.conf", help="path to save config (default: cros.conf)")
    parser.add_argument("-i", "--inverted", action="store_true", 
                        help="use functional keys by default and media keys when super is held")
    args = vars(parser.parse_args())

    

    physmap = get_physmap_data()
    if not physmap:
        if get_arch() == "x86_64":
            physmap = ['EA', 'E9', 'E7', '91', '92', '94', '95', 'A0', 'AE', 'B0']
        else:
            physmap = ['158', '159', '173', '372', '120', '224', '225', '113', '114', '115']
    
    config = get_keyd_config(physmap, args["inverted"])
    print(config)

if __name__ == "__main__":
    if get_arch() != "x86_64":
        import libfdt
    main()
