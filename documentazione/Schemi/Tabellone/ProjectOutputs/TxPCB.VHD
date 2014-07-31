------------------------------------------------------------
-- VHDL TxPCB
-- 2014 7 27 19 39 50
-- Created By "DXP VHDL Generator"
-- "Copyright (c) 2002-2014 Altium Limited"
-- Product Version: 14.3.13.34012
------------------------------------------------------------

------------------------------------------------------------
-- VHDL TxPCB
------------------------------------------------------------

Library IEEE;
Use     IEEE.std_logic_1164.all;

Entity TxPCB Is
  attribute MacroCell : boolean;

End TxPCB;
------------------------------------------------------------

------------------------------------------------------------
Architecture Structure Of TxPCB Is
   Component Battery                                         -- ObjectKind=Part|PrimaryId=BT?|SecondaryId=1
      port
      (
        X_1 : inout STD_LOGIC;                               -- ObjectKind=Pin|PrimaryId=BT?-1
        X_2 : inout STD_LOGIC                                -- ObjectKind=Pin|PrimaryId=BT?-2
      );
   End Component;

   Component Cap                                             -- ObjectKind=Part|PrimaryId=C?|SecondaryId=1
      port
      (
        X_1 : inout STD_LOGIC;                               -- ObjectKind=Pin|PrimaryId=C?-1
        X_2 : inout STD_LOGIC                                -- ObjectKind=Pin|PrimaryId=C?-2
      );
   End Component;

   Component Cap_Pol1                                        -- ObjectKind=Part|PrimaryId=C?|SecondaryId=1
      port
      (
        X_1 : inout STD_LOGIC;                               -- ObjectKind=Pin|PrimaryId=C?-1
        X_2 : inout STD_LOGIC                                -- ObjectKind=Pin|PrimaryId=C?-2
      );
   End Component;

   Component Header_15H                                      -- ObjectKind=Part|PrimaryId=P?|SecondaryId=1
      port
      (
        X_1  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-1
        X_2  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-2
        X_3  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-3
        X_4  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-4
        X_5  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-5
        X_6  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-6
        X_7  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-7
        X_8  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-8
        X_9  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-9
        X_10 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-10
        X_11 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-11
        X_12 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-12
        X_13 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-13
        X_14 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=P?-14
        X_15 : inout STD_LOGIC                               -- ObjectKind=Pin|PrimaryId=P?-15
      );
   End Component;

   Component LED1                                            -- ObjectKind=Part|PrimaryId=D?|SecondaryId=1
      port
      (
        X_1 : inout STD_LOGIC;                               -- ObjectKind=Pin|PrimaryId=D?-1
        X_2 : inout STD_LOGIC                                -- ObjectKind=Pin|PrimaryId=D?-2
      );
   End Component;

   Component NRF24L01P                                       -- ObjectKind=Part|PrimaryId=*|SecondaryId=1
      port
      (
        X_1 : inout STD_LOGIC;                               -- ObjectKind=Pin|PrimaryId=*-1
        X_2 : inout STD_LOGIC;                               -- ObjectKind=Pin|PrimaryId=*-2
        X_3 : inout STD_LOGIC;                               -- ObjectKind=Pin|PrimaryId=*-3
        X_4 : inout STD_LOGIC;                               -- ObjectKind=Pin|PrimaryId=*-4
        X_5 : inout STD_LOGIC;                               -- ObjectKind=Pin|PrimaryId=*-5
        X_6 : inout STD_LOGIC;                               -- ObjectKind=Pin|PrimaryId=*-6
        X_7 : inout STD_LOGIC;                               -- ObjectKind=Pin|PrimaryId=*-7
        X_8 : inout STD_LOGIC                                -- ObjectKind=Pin|PrimaryId=*-8
      );
   End Component;

   Component PIC18F27J53MINUSI_SP                            -- ObjectKind=Part|PrimaryId=U1|SecondaryId=1
      port
      (
        X_1  : in    STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-1
        X_2  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-2
        X_3  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-3
        X_4  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-4
        X_5  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-5
        X_6  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-6
        X_7  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-7
        X_8  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-8
        X_9  : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-9
        X_10 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-10
        X_11 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-11
        X_12 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-12
        X_13 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-13
        X_14 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-14
        X_15 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-15
        X_16 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-16
        X_17 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-17
        X_18 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-18
        X_19 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-19
        X_20 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-20
        X_21 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-21
        X_22 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-22
        X_23 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-23
        X_24 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-24
        X_25 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-25
        X_26 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-26
        X_27 : inout STD_LOGIC;                              -- ObjectKind=Pin|PrimaryId=U1-27
        X_28 : inout STD_LOGIC                               -- ObjectKind=Pin|PrimaryId=U1-28
      );
   End Component;

   Component Res1                                            -- ObjectKind=Part|PrimaryId=R?|SecondaryId=1
      port
      (
        X_1 : inout STD_LOGIC;                               -- ObjectKind=Pin|PrimaryId=R?-1
        X_2 : inout STD_LOGIC                                -- ObjectKind=Pin|PrimaryId=R?-2
      );
   End Component;


    Signal NamedIOSignal_X_10 : STD_LOGIC;
    Signal NamedIOSignal_X_11 : STD_LOGIC;
    Signal NamedIOSignal_X_12 : STD_LOGIC;
    Signal NamedIOSignal_X_13 : STD_LOGIC;
    Signal NamedIOSignal_X_15 : STD_LOGIC;
    Signal NamedIOSignal_X_16 : STD_LOGIC;
    Signal NamedIOSignal_X_17 : STD_LOGIC;
    Signal NamedIOSignal_X_18 : STD_LOGIC;
    Signal NamedIOSignal_X_2 : STD_LOGIC;
    Signal NamedIOSignal_X_21 : STD_LOGIC;
    Signal NamedIOSignal_X_22 : STD_LOGIC;
    Signal NamedIOSignal_X_23 : STD_LOGIC;
    Signal NamedIOSignal_X_24 : STD_LOGIC;
    Signal NamedIOSignal_X_25 : STD_LOGIC;
    Signal NamedIOSignal_X_26 : STD_LOGIC;
    Signal NamedIOSignal_X_27 : STD_LOGIC;
    Signal NamedIOSignal_X_28 : STD_LOGIC;
    Signal NamedIOSignal_X_3 : STD_LOGIC;
    Signal NamedIOSignal_X_4 : STD_LOGIC;
    Signal NamedIOSignal_X_5 : STD_LOGIC;
    Signal NamedIOSignal_X_7 : STD_LOGIC;
    Signal NamedIOSignal_X_9 : STD_LOGIC;

   attribute DatasheetVersion : string;
   attribute DatasheetVersion of U1 : Label is "Rev. B";

   attribute Digital_Communication : string;
   attribute Digital_Communication of U1 : Label is "2 -A/E/USART, 2 -MSSP(SPI/I2C)";

   attribute I_O_Pins : string;
   attribute I_O_Pins of U1 : Label is "22";

   attribute Internal_Oscillator : string;
   attribute Internal_Oscillator of U1 : Label is "8 MHz, 31 kHz";

   attribute Max_CPU_Speed_MHz : string;
   attribute Max_CPU_Speed_MHz of U1 : Label is "48";

   attribute Mounting_Technology : string;
   attribute Mounting_Technology of U1 : Label is "Through Hole";

   attribute Operation_Voltage_Range : string;
   attribute Operation_Voltage_Range of U1 : Label is "2.15V - 3.6V";

   attribute PackageDescription : string;
   attribute PackageDescription of U1  : Label is "28-Lead Plastic Dual In-Line, 34.86 x 6.79 mm Body, 2.54 mm Pitch";
   attribute PackageDescription of R?  : Label is "Axial Device, Thru-Hole; 2 Leads; 0.3 in Pin Spacing";
   attribute PackageDescription of D?  : Label is "LED; 2 Leads";
   attribute PackageDescription of C?  : Label is "Polarized Capacitor (Radial); 2 Leads";
   attribute PackageDescription of BT? : Label is "Battery; 2 Leads";

   attribute PackageReference : string;
   attribute PackageReference of U1  : Label is "SPDIP-SP28";
   attribute PackageReference of R?  : Label is "AXIAL-0.3";
   attribute PackageReference of D?  : Label is "LED-1";
   attribute PackageReference of C?  : Label is "RB7.6-15";
   attribute PackageReference of BT? : Label is "BAT-2";

   attribute PackageVersion : string;
   attribute PackageVersion of U1 : Label is "C04-070B, 12/2012";

   attribute Packing : string;
   attribute Packing of U1 : Label is "TUBE";

   attribute PartNumber : string;
   attribute PartNumber of U1 : Label is "PIC18F27J53-I/SP";

   attribute Program_Memory_KBytes : string;
   attribute Program_Memory_KBytes of U1 : Label is "128";

   attribute Program_Memory_KWords : string;
   attribute Program_Memory_KWords of U1 : Label is "64";

   attribute RAM : string;
   attribute RAM of U1 : Label is "3800";

   attribute RoHS : string;
   attribute RoHS of U1 : Label is "TRUE";

   attribute Supplier_1 : string;
   attribute Supplier_1 of U1 : Label is "Digi-Key";

   attribute Supplier_2 : string;
   attribute Supplier_2 of U1 : Label is "Farnell";

   attribute Supplier_3 : string;
   attribute Supplier_3 of U1 : Label is "Newark";

   attribute Supplier_4 : string;
   attribute Supplier_4 of U1 : Label is "Mouser";

   attribute Supplier_Part_Number_1 : string;
   attribute Supplier_Part_Number_1 of U1 : Label is "PIC18F27J53-I/SP-ND";

   attribute Supplier_Part_Number_2 : string;
   attribute Supplier_Part_Number_2 of U1 : Label is "1814996";

   attribute Supplier_Part_Number_3 : string;
   attribute Supplier_Part_Number_3 of U1 : Label is "63R7839";

   attribute Supplier_Part_Number_4 : string;
   attribute Supplier_Part_Number_4 of U1 : Label is "579-PIC18F27J53-I/SP";

   attribute Timers : string;
   attribute Timers of U1 : Label is "4 - 8-bit, 4 - 16-bit";

   attribute Value : string;
   attribute Value of R? : Label is "1K";
   attribute Value of C? : Label is "100pF";

   attribute X_of_A_D_Channels : string;
   attribute X_of_A_D_Channels of U1 : Label is "10";


Begin
    U1 : PIC18F27J53MINUSI_SP                                -- ObjectKind=Part|PrimaryId=U1|SecondaryId=1
      Port Map
      (
        X_2  => NamedIOSignal_X_2,                           -- ObjectKind=Pin|PrimaryId=U1-2
        X_3  => NamedIOSignal_X_3,                           -- ObjectKind=Pin|PrimaryId=U1-3
        X_4  => NamedIOSignal_X_4,                           -- ObjectKind=Pin|PrimaryId=U1-4
        X_5  => NamedIOSignal_X_5,                           -- ObjectKind=Pin|PrimaryId=U1-5
        X_7  => NamedIOSignal_X_7,                           -- ObjectKind=Pin|PrimaryId=U1-7
        X_9  => NamedIOSignal_X_9,                           -- ObjectKind=Pin|PrimaryId=U1-9
        X_10 => NamedIOSignal_X_10,                          -- ObjectKind=Pin|PrimaryId=U1-10
        X_11 => NamedIOSignal_X_11,                          -- ObjectKind=Pin|PrimaryId=U1-11
        X_12 => NamedIOSignal_X_12,                          -- ObjectKind=Pin|PrimaryId=U1-12
        X_13 => NamedIOSignal_X_13,                          -- ObjectKind=Pin|PrimaryId=U1-13
        X_15 => NamedIOSignal_X_15,                          -- ObjectKind=Pin|PrimaryId=U1-15
        X_16 => NamedIOSignal_X_16,                          -- ObjectKind=Pin|PrimaryId=U1-16
        X_17 => NamedIOSignal_X_17,                          -- ObjectKind=Pin|PrimaryId=U1-17
        X_18 => NamedIOSignal_X_18,                          -- ObjectKind=Pin|PrimaryId=U1-18
        X_21 => NamedIOSignal_X_21,                          -- ObjectKind=Pin|PrimaryId=U1-21
        X_22 => NamedIOSignal_X_22,                          -- ObjectKind=Pin|PrimaryId=U1-22
        X_23 => NamedIOSignal_X_23,                          -- ObjectKind=Pin|PrimaryId=U1-23
        X_24 => NamedIOSignal_X_24,                          -- ObjectKind=Pin|PrimaryId=U1-24
        X_25 => NamedIOSignal_X_25,                          -- ObjectKind=Pin|PrimaryId=U1-25
        X_26 => NamedIOSignal_X_26,                          -- ObjectKind=Pin|PrimaryId=U1-26
        X_27 => NamedIOSignal_X_27,                          -- ObjectKind=Pin|PrimaryId=U1-27
        X_28 => NamedIOSignal_X_28                           -- ObjectKind=Pin|PrimaryId=U1-28
      );

    R : Res1                                                 -- ObjectKind=Part|PrimaryId=R?|SecondaryId=1
;

    P : Header_15H                                           -- ObjectKind=Part|PrimaryId=P?|SecondaryId=1
;

    D : LED1                                                 -- ObjectKind=Part|PrimaryId=D?|SecondaryId=1
;

    C : Cap_Pol1                                             -- ObjectKind=Part|PrimaryId=C?|SecondaryId=1
;

    C : Cap                                                  -- ObjectKind=Part|PrimaryId=C?|SecondaryId=1
;

    BT : Battery                                             -- ObjectKind=Part|PrimaryId=BT?|SecondaryId=1
;

    X : NRF24L01P                                            -- ObjectKind=Part|PrimaryId=*|SecondaryId=1
;

End Structure;
------------------------------------------------------------

