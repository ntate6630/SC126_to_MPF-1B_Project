# SC126_to_MPF-1B_Project
# Micro Professor MPF-1B add-on for the SC126.

# Why do this?
My reason for doing this is because I enjoy working in machine code and hand assembly with a dedicated HEX keyboard/display in this very low level way with minimal interference from the operating system.
I started out in 1990 buying my first Z80 computer kit from Maplin electronics. This had a mainboard and a keypad with 7 segment displays allowing basic entry and running of machine code then at college was my introduction to the Micro Professor and with its more advanced features I had to build my own. Then over the last 30 years I have built many different variations of the Micro Professor each with more advanced designs each time. 

# My design
The hardware consists of the SC126 computer Z180 mainboard by Steve Cousins. Its a great system that can run either ROMWBW CP/M or SCMONITOR or be used in many different ways. 
I replaced the SCMONITOR ROM with my own and made an interface board connected to a keyboard with 7 segment LED display which I designed based on my previous 24MHz Z80 computer build.

Changes to the original design of the Micro Professor include... 

Designing new 74Fxxx series TTL logic to allow operation at high clock speeds.
Removing the cassette LOAD and SAVE circuits as the computer runs very fast now so they are'nt usefull any more, and using Z180 serial port 0 instead.
Adding a PIC microcontroller to manage the hardware /BREAK control signal at power up. 
Altering the INT key function so when pressed it generates a single INT pulse instead, using the same PIC.

The firmware is my modified MPF-1B ROM with changes as described here...

Changes to the firmware include Z180 register initialisation, 
Setting up the MMU, 
Copying the i2c bus routines from ROM to RAM once after power on reset.
Removed the cassette LOAD and SAVE routines and replaced with my serial load and save routines.
Added my i2c bus routines for loading and saving code to EEPROM'S.

All of the keyboard and display functions of the Micro professor MPF-1B are still there in my design.
The original Micro Professor can be run faster than its original 1.79MHz CPU speed but once you get above 4MHz the hardware MONI, STEP and BREAK functions dont work 
correctly because the 8255 PIA introduces too much latency.
To get around this I designed a Input/Output circuit using faster 74Fxxx series logic that replaces the addreess decoding and 8255 PIA.

In doing this it also creates an issue where the output port controlling the BREAK signal will be in an undefined state at power up which can cause 
a /NMI interrupt before the firmware has had a chance to initialise the system hardware and software properly after power up. So I have a transistor to disable 
the BREAK signal from the 74F573 output port to the 74LS90 decade counter that controls the /NMI line. A PIC12F675 microcontroller controls the transistor and at 
power up waits three seconds before turning the transistor ON giving adequate time to initialise everything. 
Once the transistor is ON after three seconds the user can freely use the MONI key and single step key and hardware breakpoint functions in the same way as the 
original Micro Professor. The speed of 74Fxxx series logic is so fast there are no latency issues even when the CPU is running at 36864 MHZ.
I now have a Micro Professor that now runs 20 times faster!!!


