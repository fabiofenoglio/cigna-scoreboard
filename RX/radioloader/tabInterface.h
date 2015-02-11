#ifndef _incl_tabInterface_h
#define _incl_tabInterface_h

/* Costanti ================================================================= */

const uint32 ___TAB_TIME_BIT_SETTING_US =   100;
const uint32 ___TAB_TIME_CLOCK_ACTIVE_US =  100;
const uint32 ___TAB_TIME_CLOCK_OFF_US =     100;
const uint32 ___TAB_TIME_STROBE_ACTIVE_US = 100;
const uint32 ___TAB_TIME_STROBE_OFF_US =    100;

#define n__d 0x40

const uint8 ___TAB_CHARMAP[] =
{
/* 000 -   */ n__d,/* 001 -   */ n__d,/* 002 -   */ n__d,/* 003 -   */ n__d,
/* 004 -   */ n__d,/* 005 -   */ n__d,/* 006 -   */ n__d,/* 007 -   */ n__d,
/* 008 -   */ n__d,/* 009 -   */ n__d,/* 010 -   */ n__d,/* 011 -   */ n__d,
/* 012 -   */ n__d,/* 013 -   */ n__d,/* 014 -   */ n__d,/* 015 -   */ n__d,
/* 016 -   */ n__d,/* 017 -   */ n__d,/* 018 -   */ n__d,/* 019 -   */ n__d,
/* 020 -   */ n__d,/* 021 -   */ n__d,/* 022 -   */ n__d,/* 023 -   */ n__d,
/* 024 -   */ n__d,/* 025 -   */ n__d,/* 026 -   */ n__d,/* 027 -   */ n__d,
/* 028 -   */ n__d,/* 029 -   */ n__d,/* 030 -   */ n__d,/* 031 -   */ n__d,
/* 032 -   */ 0x00,/* 033 - ! */ 0x0A,/* 034 - " */ 0x22,/* 035 - # */ 0x7E,
/* 036 - $ */ 0x6D,/* 037 - % */ 0x52,/* 038 - & */ 0x7F,/* 039 - ' */ 0x02,
/* 040 - ( */ 0x39,/* 041 - ) */ 0x0F,/* 042 - * */ 0x63,/* 043 - + */ 0x46,
/* 044 - , */ 0x0C,/* 045 - - */ 0x40,/* 046 - . */ 0x08,/* 047 - / */ 0x52,
/* 048 - 0 */ 0x3f,/* 049 - 1 */ 0x06,/* 050 - 2 */ 0x5b,/* 051 - 3 */ 0x4f,
/* 052 - 4 */ 0x66,/* 053 - 5 */ 0x6d,/* 054 - 6 */ 0x7d,/* 055 - 7 */ 0x07,
/* 056 - 8 */ 0x7f,/* 057 - 9 */ 0x6f,/* 058 - : */ 0x06,/* 059 - ; */ 0x0E,
/* 060 - < */ 0x58,/* 061 - = */ 0x48,/* 062 - > */ 0x4C,/* 063 - ? */ 0x4B,
/* 064 - @ */ 0x7B,/* 065 - A */ 0x77,/* 066 - B */ 0x7f,/* 067 - C */ 0x39,
/* 068 - D */ 0x5e,/* 069 - E */ 0x79,/* 070 - F */ 0x71,/* 071 - G */ 0x3d,
/* 072 - H */ 0x76,/* 073 - I */ 0x06,/* 074 - J */ 0x0e,/* 075 - K */ 0x76,
/* 076 - L */ 0x38,/* 077 - M */ 0x37,/* 078 - N */ 0x37,/* 079 - O */ 0x3F,
/* 080 - P */ 0x73,/* 081 - Q */ 0x7F,/* 082 - R */ 0x77,/* 083 - S */ 0x6D,
/* 084 - T */ 0x07,/* 085 - U */ 0x3E,/* 086 - V */ 0x3E,/* 087 - W */ 0x3E,
/* 088 - X */ 0x76,/* 089 - Y */ 0x66,/* 090 - Z */ 0x5B,/* 091 - [ */ 0x39,
/* 092 - \ */ 0x64,/* 093 - ] */ 0x0F,/* 094 - ^ */ 0x23,/* 095 - _ */ 0x08,
/* 096 - ` */ 0x01,/* 097 - a */ 0x77,/* 098 - b */ 0x7c,/* 099 - c */ 0x58,
/* 100 - d */ 0x5e,/* 101 - e */ 0x7b,/* 102 - f */ 0x71,/* 103 - g */ 0x6f,
/* 104 - h */ 0x74,/* 105 - i */ 0x06,/* 106 - j */ 0x0E,/* 107 - k */ 0x76,
/* 108 - l */ 0x38,/* 109 - m */ 0x54,/* 110 - n */ 0x54,/* 111 - o */ 0x5C,
/* 112 - p */ 0x73,/* 113 - q */ 0x67,/* 114 - r */ 0x50,/* 115 - s */ 0x6D,
/* 116 - t */ 0x31,/* 117 - u */ 0x1C,/* 118 - v */ 0x1C,/* 119 - w */ 0x1C,
/* 120 - x */ 0x76,/* 121 - y */ 0x66,/* 122 - z */ 0x5B,/* 123 - { */ 0x39,
/* 124 - | */ 0x06,/* 125 - } */ 0x0F,/* 126 - ~ */ 0x40,/* 127 -   */ n__d,
/* 128 - Ä */ 0x79,/* 129 - Å */ 0x00,/* 130 - Ç */ 0x0C,/* 131 - É */ 0x71,
/* 132 - Ñ */ 0x0C,/* 133 - Ö */ 0x08,/* 134 - Ü */ n__d,/* 135 - á */ n__d,
/* 136 - à */ n__d,/* 137 - â */ n__d,/* 138 - ä */ n__d,/* 139 - ã */ n__d,
/* 140 - å */ n__d,/* 141 - ç */ n__d,/* 142 - é */ n__d,/* 143 - è */ n__d,
/* 144 - ê */ n__d,/* 145 - ë */ 0x02,/* 146 - í */ 0x02,/* 147 - ì */ 0x22,
/* 148 - î */ 0x22,/* 149 - ï */ 0x40,/* 150 - ñ */ 0x40,/* 151 - ó */ 0x40,
/* 152 - ò */ 0x01,/* 153 - ô */ n__d,/* 154 - ö */ n__d,/* 155 - õ */ n__d,
/* 156 - ú */ n__d,/* 157 - ù */ n__d,/* 158 - û */ n__d,/* 159 - ü */ n__d,
/* 160 - † */ n__d,/* 161 - ° */ n__d,/* 162 - ¢ */ n__d,/* 163 - £ */ n__d,
/* 164 - § */ n__d,/* 165 - • */ n__d,/* 166 - ¶ */ 0x06,/* 167 - ß */ 0x6D,
/* 168 - ® */ 0x01,/* 169 - © */ n__d,/* 170 - ™ */ n__d,/* 171 - ´ */ n__d,
/* 172 - ¨ */ n__d,/* 173 - ≠ */ n__d,/* 174 - Æ */ n__d,/* 175 - Ø */ n__d,
/* 176 - ∞ */ n__d,/* 177 - ± */ n__d,/* 178 - ≤ */ n__d,/* 179 - ≥ */ n__d,
/* 180 - ¥ */ n__d,/* 181 - µ */ 0x72,/* 182 - ∂ */ n__d,/* 183 - ∑ */ n__d,
/* 184 - ∏ */ 0x08,/* 185 - π */ n__d,/* 186 - ∫ */ n__d,/* 187 - ª */ n__d,
/* 188 - º */ n__d,/* 189 - Ω */ n__d,/* 190 - æ */ n__d,/* 191 - ø */ n__d,
/* 192 - ¿ */ 0x77,/* 193 - ¡ */ 0x77,/* 194 - ¬ */ 0x77,/* 195 - √ */ 0x77,
/* 196 - ƒ */ 0x77,/* 197 - ≈ */ 0x77,/* 198 - ∆ */ 0x79,/* 199 - « */ 0x39,
/* 200 - » */ 0x79,/* 201 - … */ 0x79,/* 202 -   */ 0x79,/* 203 - À */ 0x79,
/* 204 - Ã */ 0x06,/* 205 - Õ */ 0x06,/* 206 - Œ */ 0x06,/* 207 - œ */ 0x06,
/* 208 - – */ 0x5E,/* 209 - — */ 0x37,/* 210 - “ */ 0x3F,/* 211 - ” */ 0x3F,
/* 212 - ‘ */ 0x3F,/* 213 - ’ */ 0x3F,/* 214 - ÷ */ 0x3F,/* 215 - ◊ */ n__d,
/* 216 - ÿ */ 0x3F,/* 217 - Ÿ */ 0x3E,/* 218 - ⁄ */ 0x3E,/* 219 - € */ 0x3E,
/* 220 - ‹ */ 0x3E,/* 221 - › */ 0x66,/* 222 - ﬁ */ n__d,/* 223 - ﬂ */ 0x7C,
/* 224 - ‡ */ 0x5F,/* 225 - · */ 0x5F,/* 226 - ‚ */ 0x5F,/* 227 - „ */ 0x5F,
/* 228 - ‰ */ 0x5F,/* 229 - Â */ 0x5F,/* 230 - Ê */ 0x5F,/* 231 - Á */ 0x58,
/* 232 - Ë */ 0x7B,/* 233 - È */ 0x7B,/* 234 - Í */ 0x7B,/* 235 - Î */ 0x7B,
/* 236 - Ï */ 0x06,/* 237 - Ì */ 0x06,/* 238 - Ó */ 0x06,/* 239 - Ô */ 0x06,
/* 240 -  */ n__d,/* 241 - Ò */ 0x54,/* 242 - Ú */ 0x5C,/* 243 - Û */ 0x5C,
/* 244 - Ù */ 0x5C,/* 245 - ı */ 0x5C,/* 246 - ˆ */ 0x5C,/* 247 - ˜ */ n__d,
/* 248 - ¯ */ 0x5C,/* 249 - ˘ */ 0x1C,/* 250 - ˙ */ 0x1C,/* 251 - ˚ */ 0x1C,
/* 252 - ¸ */ 0x1C,/* 253 - ˝ */ 0x66,/* 254 - ˛ */ n__d,/* 255 - ˇ */ 0x66
};

/* Prototipi ================================================================ */

void tab_init                ();
void tab_send_string         (uint8* string, uint8 num);
void tab_send_num            (uint8 num);

void tab_strobe_locals       ();
void tab_strobe_guests       ();
void tab_strobe_time         ();

void tab_send_byte           (uint8 byteToSend);
// MACRO ___tab_get_codified_number    (uint8 number);
// MACRO ___tab_get_codified_character (uint8 character);
// MACRO ___tab_strobe                 (pin)

void tab_display_msg         (char* string, uint8 num);

/* Implementazioni ========================================================== */

#define ___tab_strobe(pin) { \
    pin = 1; Delay_us(___TAB_TIME_STROBE_ACTIVE_US); \
    pin = 0; Delay_us(___TAB_TIME_STROBE_OFF_US); }
#define ___tab_get_codified_number(n) ___TAB_CHARMAP[n + '0']
#define ___tab_get_codified_character(c) ___TAB_CHARMAP[c]

void tab_init()
{
    pin_dato =    0;
    pin_clock =   0;
    pin_locali =  0;
    pin_tempo =   0;
    pin_ospiti =  0;
    pin_claxon =  0;
    
    pin_dato_dir =    OUTPUT;
    pin_clock_dir =   OUTPUT;
    pin_locali_dir =  OUTPUT;
    pin_tempo_dir =   OUTPUT;
    pin_ospiti_dir =  OUTPUT;
    pin_claxon_dir =  OUTPUT;
    
    #if DEBUG
        debug_uart_init();
        debug_uart_send_text("uart debug ON");
    #endif
}

void tab_send_byte(uint8 byteToSend)
{
    uint8 i;

    for (i = 0; i < 8; i ++)
    {
        pin_dato = ! byteToSend.B7;
        Delay_us(___TAB_TIME_BIT_SETTING_US);
        
        pin_clock = 1;
        Delay_us(___TAB_TIME_CLOCK_ACTIVE_US);
        pin_clock = 0;
        Delay_us(___TAB_TIME_CLOCK_OFF_US);
        
        byteToSend = byteToSend << 1;
    }
    
    pin_dato = 0;
}

void tab_send_num(uint8 num)
{
    tab_send_byte(___tab_get_codified_number(num));
}

void tab_display_msg(char* string, uint8 num)
{
    uint8 len;
    
    tab_send_string("    ", 4);
    tab_strobe_locals();
    tab_strobe_guests();
    
    len = num;
    while (len++ < 4) tab_send_byte(0x00);
    tab_send_string(string, num);
    ___tab_strobe(pin_tempo);
}

void tab_send_string(uint8* string, uint8 num)
{
    uint8 counter = 0;
    
    #if DEBUG
    debug_sprinti_1("str '%s'", string);
    #endif
    
    while (num --)
    {
        tab_send_byte(___tab_get_codified_character(string[counter ++]));
    }
}

void tab_strobe_locals()
{
    #if DEBUG
    debug_print("strobe loc");
    #endif
    ___tab_strobe(pin_locali);
}

void tab_strobe_guests()
{
    #if DEBUG
    debug_print("strobe osp");
    #endif
    ___tab_strobe(pin_ospiti);
}

void tab_strobe_time()
{
    #if DEBUG
    debug_print("strobe time");
    #endif
    ___tab_strobe(pin_tempo);
}

#endif