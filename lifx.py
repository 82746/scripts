import sys
import lifxlan

def toggle_power(bulb):
    current_state = bulb.get_power()

    if current_state == 65535:
        bulb.set_power(0)

    elif current_state == 0:
        bulb.set_power(65535)


def main():
    lifx = lifxlan.LifxLAN(1)
    if len(lifx.get_lights()) < 1:
        print("no light bulbs found in lan.")
        exit(1)

    bulb = lifx.get_lights()[0]
    print("name:",bulb.get_label(),"\nip:",bulb.get_ip_addr())

    options={}
    i=1
    while i < len(sys.argv):
        if str(sys.argv[i]).startswith("-"):
            options[sys.argv[i]] = []
            
            x = i+1
            while True:
                options[sys.argv[i]].append(sys.argv[x])

                if x+1 < len(sys.argv):
                    if sys.argv[x+1].startswith("-"):
                        break

                    x += 1
                else:
                    break

        i += 1

    for i in options:
        if i == "-p":
            if options[i][0] == "on" or options[i][0] == "off":
                bulb.set_power(str(options[i][0]))

            elif options[i][0] == "toggle":
                toggle_power(bulb)

            else:
                print("usage: \npower [toggle/on/off]")
        
        elif i == "-b":
            normalized_brightness = int(options[i])*65535/100
            bulb.set_brightness(normalized_brightness)

        elif i == "-hsl":
            normalized_hue = int(options[i][0])*65535/360
            normalized_saturation = int(options[i][1])*65535/100
            normalized_lightness = int(options[i][2])*65535/100
            bulb.set_color([normalized_hue,normalized_saturation,normalized_lightness,3500])

        else:
            print(f'unkown command "{i}"')
            break

if __name__ == "__main__":
    main()
