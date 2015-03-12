#ifndef _inclguard_protocl_h
#define _inclguard_protocl_h

#define HOOK_TIME 1000
#define ERROR_SHOW_TIME 5000

#define BYTES_BEFORE_DATA 5
#define DATA_BYTES_PER_PACKET 16
#define BYTES_PER_PACKET (DATA_BYTES_PER_PACKET + BYTES_BEFORE_DATA)
#define FIRST_DATA_BYTE_INDEX BYTES_BEFORE_DATA

#define USER_APP_ENTRY_POINT 0x1C00
#define LAST_USEFUL_FLASH_ADDRESS 0x1FFF7
#define LAST_USEFUL_FLASH_PAGE_FIRST_ADDRESS 0x1FC00
#define FLASH_ERASE_BLOCK_SIZE 1024
#define FLASH_WRITE_BLOCK_SIZE 64

#define CHUNK_1_SIZE 65535
#define CHUNK_2_SIZE 57345
#define CHUNK_1_ADDRESS (USER_APP_ENTRY_POINT)
#define CHUNK_2_ADDRESS (CHUNK_1_ADDRESS + (CHUNK_1_SIZE))

#define EMPTY_CHECK_SEQUENCE_LEN 8
#define EMPTY_CHECK_SEQUENCE 0xFF, 0xFE, 0x00, 0x01, 0x13, 0x25, 0x60, 0xAB

const code EMPTY_CHECK_SEQUENCE_FIXED[EMPTY_CHECK_SEQUENCE_LEN] = {EMPTY_CHECK_SEQUENCE};
const code byte MEMORY_CHUNK_1[CHUNK_1_SIZE] = {EMPTY_CHECK_SEQUENCE} absolute CHUNK_1_ADDRESS;
const code byte MEMORY_CHUNK_2[CHUNK_2_SIZE] = {0} absolute CHUNK_2_ADDRESS;

/* Packet format:
 * 0       cmd (1 byte)
 * 1 - 4   memory address (4 bytes)
 * 5 - 20 data (16 bytes)
 * bit order is MSB - LSB
*/
typedef struct
{
    uint8 command;
    uint32 address;

    byte data_bytes [DATA_BYTES_PER_PACKET];

} packet;

const uint8 cmd_none =           0x00;
const uint8 cmd_write_buffer =   0x01;
const uint8 cmd_clear_buffer =   0x02;
const uint8 cmd_write_flash =    0x03;
const uint8 cmd_erase_flash =    0x04;
const uint8 cmd_reboot =         0x10;
const uint8 cmd_start_user_app = 0x11;

void parse_packet(uint8 * buffer);
void execute_packet();

void protocolcmd_write_buffer();
void protocolcmd_clear_buffer();
void protocolcmd_erase_flash();
void protocolcmd_write_flash();

byte flash_write_buffer[FLASH_WRITE_BLOCK_SIZE];
packet in_packet = {cmd_none, 0, 0};

#endif // #ifndef _inclguard_protocl_h