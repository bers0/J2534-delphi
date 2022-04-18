unit uPassThruConst;

interface

type TErrorDescription=record
  id: Byte;
  Description: string;
end;

const
////////////////
// Protocol IDs
////////////////

// J2534-1
J1850VPW     = 1;
J1850PWM     = 2;
ISO9141      = 3;
ISO14230     = 4;
CAN          = 5;
ISO15765     = 6;
SCI_A_ENGINE = 7;   // OP2.0: Not supported
SCI_A_TRANS  = 8;   // OP2.0: Not supported
SCI_B_ENGINE = 9;   // OP2.0: Not supported
SCI_B_TRANS  = 10;// OP2.0: Not supported

// J2534-2
CAN_CH1      = $00009000;
J1850VPW_CH1 = $00009080;
J1850PWM_CH1 = $00009160;
ISO9141_CH1  = $00009240;
ISO9141_CH2  = $00009241;
ISO9141_CH3  = $00009242;
ISO9141_K    = ISO9141_CH1;
ISO9141_L    = ISO9141_CH2;     // OP2.0: Support for ISO9141 communications over the L line
ISO9141_INNO = ISO9141_CH3;     // OP2.0: Support for RS-232 receive-only communications via the 2.5mm jack
ISO14230_CH1 = $00009320;
ISO14230_CH2 = $00009321;
ISO14230_K   = ISO14230_CH1;
ISO14230_L   = ISO14230_CH2;    // OP2.0: Support for ISO14230 communications over the L line
ISO15765_CH1 = $00009400;


/////////////
// IOCTL IDs
/////////////

// J2534-1
GET_CONFIG                         = $01;
SET_CONFIG                         = $02;
READ_VBATT                         = $03;
FIVE_BAUD_INIT                     = $04;
FAST_INIT                          = $05;
CLEAR_TX_BUFFER                    = $07;
CLEAR_RX_BUFFER                    = $08;
CLEAR_PERIODIC_MSGS                = $09;
CLEAR_MSG_FILTERS                  = $0A;
CLEAR_FUNCT_MSG_LOOKUP_TABLE       = $0B;   // OP2.0: Not yet supported
ADD_TO_FUNCT_MSG_LOOKUP_TABLE      = $0C; // OP2.0: Not yet supported
DELETE_FROM_FUNCT_MSG_LOOKUP_TABLE = $0D; // OP2.0: Not yet supported
READ_PROG_VOLTAGE                  = $0E;   // OP2.0: Several pins are supported

// J2534-2
SW_CAN_NS   = $8000; // OP2.0: Not supported
SW_CAN_HS   = $8001; // OP2.0: Not supported

// Tactrix specific IOCTLs
TX_IOCTL_BASE                           = $70000;
// OP2.0: The IOCTL below supports application-specific functions
// that can be built into the hardware
TX_IOCTL_APP_SERVICE                    = (TX_IOCTL_BASE+0);
TX_IOCTL_SET_DLL_DEBUG_FLAGS            = (TX_IOCTL_BASE+1);
TX_IOCTL_DLL_DEBUG_FLAG_J2534_CALLS     = $00000001;
TX_IOCTL_DLL_DEBUG_FLAG_ALL_DEV_COMMS   = $00000002;
TX_IOCTL_SET_DEV_DEBUG_FLAGS            = (TX_IOCTL_BASE+2);
TX_IOCTL_DEV_DEBUG_FLAG_USB_COMMS       = $00000001;
TX_IOCTL_SET_DLL_STATUS_CALLBACK        = (TX_IOCTL_BASE+3);
TX_IOCTL_GET_DEVICE_INSTANCES           = (TX_IOCTL_BASE+4);

/////////////////
// Pin numbering
/////////////////
AUX_PIN      = 0;    // aux jack OP2.0: Supports GND and adj. voltage
J1962_PIN_1  = 1;  //          OP2.0: Supports GND and adj. voltage
J1962_PIN_2  = 2;  // J1850P   OP2.0: Supports 5V and 8V
J1962_PIN_3  = 3;  //          OP2.0: Supports GND and adj. voltage
J1962_PIN_4  = 4;  // GND
J1962_PIN_5  = 5;  // GND
J1962_PIN_6  = 6;  // CAN
J1962_PIN_7  = 7;  // K        OP2.0: Supports GND
J1962_PIN_8  = 8;  //          OP2.0: Supports reading voltage
J1962_PIN_9  = 9;  //          OP2.0: Supports GND and adj. voltage
J1962_PIN_10 = 10; // J1850M   OP2.0: Supports GND
J1962_PIN_11 = 11; //          OP2.0: Supports GND and adj. voltage
J1962_PIN_12 = 12; //          OP2.0: Supports GND and adj. voltage
J1962_PIN_13 = 13;     //          OP2.0: Supports GND and adj. voltage
J1962_PIN_14 = 14; // CAN
J1962_PIN_15 = 15; // L        OP2.0: Supports GND
J1962_PIN_16 = 16; // VBAT     OP2.0: Supports reading voltage
PIN_VADJ     = 17;   // internal OP2.0: Supports reading voltage

////////////////////////////////
// Special pin voltage settings
////////////////////////////////
SHORT_TO_GROUND = $FFFFFFFE;
VOLTAGE_OFF     = $FFFFFFFF;


/////////////////////////////////////////
// GET_CONFIG / SET_CONFIG Parameter IDs
/////////////////////////////////////////

// J2534-1
DATA_RATE        = $01;
LOOPBACK         = $03;
NODE_ADDRESS     = $04; // OP2.0: Not yet supported
NETWORK_LINE     = $05; // OP2.0: Not yet supported
P1_MIN           = $06; // J2534 says this may not be changed
P1_MAX           = $07;
P2_MIN           = $08; // J2534 says this may not be changed
P2_MAX           = $09; // J2534 says this may not be changed
P3_MIN           = $0A;
P3_MAX           = $0B; // J2534 says this may not be changed
P4_MIN           = $0C;
P4_MAX           = $0D; // J2534 says this may not be changed
W0               = $19;
W1               = $0E;
W2               = $0F;
W3               = $10;
W4               = $11;
W5               = $12;
TIDLE            = $13;
TINIL            = $14;
TWUP             = $15;
PARITY           = $16;
BIT_SAMPLE_POINT = $17; // OP2.0: Not yet supported
SYNC_JUMP_WIDTH  = $18; // OP2.0: Not yet supported
T1_MAX           = $1A;
T2_MAX           = $1B;
T3_MAX           = $24;
T4_MAX           = $1C;
T5_MAX           = $1D;
ISO15765_BS      = $1E;
ISO15765_STMIN   = $1F;
DATA_BITS        = $20;
FIVE_BAUD_MOD    = $21;
BS_TX            = $22;
STMIN_TX         = $23;
ISO15765_WFT_MAX = $25;

// J2534-2
CAN_MIXED_FORMAT          = $8000;
J1962_PINS                = $8001; // OP2.0: Not supported
SW_CAN_HS_DATA_RATE       = $8010; // OP2.0: Not supported
SW_CAN_SPEEDCHANGE_ENABLE = $8011; // OP2.0: Not supported
SW_CAN_RES_SWITCH         = $8012; // OP2.0: Not supported
ACTIVE_CHANNELS           = $8020; // OP2.0: Not supported
SAMPLE_RATE               = $8021; // OP2.0: Not supported
SAMPLES_PER_READING       = $8022; // OP2.0: Not supported
READINGS_PER_MSG          = $8023; // OP2.0: Not supported
AVERAGING_METHOD          = $8024; // OP2.0: Not supported
SAMPLE_RESOLUTION         = $8025; // OP2.0: Not supported
INPUT_RANGE_LOW           = $8026; // OP2.0: Not supported
INPUT_RANGE_HIGH          = $8027; // OP2.0: Not supported

// Tactrix specific parameter IDs
TX_PARAM_BASE             = $9000;
TX_PARAM_STOP_BITS        = (TX_PARAM_BASE+0);

//////////////////////
// PARITY definitions
//////////////////////
NO_PARITY   = 0;
ODD_PARITY  = 1;
EVEN_PARITY = 2;

////////////////////////////////
// CAN_MIXED_FORMAT definitions
////////////////////////////////
CAN_MIXED_FORMAT_OFF        = 0;
CAN_MIXED_FORMAT_ON         = 1;
CAN_MIXED_FORMAT_ALL_FRAMES = 2;

/////////////
// Error IDs
/////////////
// J2534-1
ERR_SUCCESS               = $00;
STATUS_NOERROR            = $00;
ERR_NOT_SUPPORTED         = $01;
ERR_INVALID_CHANNEL_ID    = $02;
ERR_INVALID_PROTOCOL_ID   = $03;
ERR_NULL_PARAMETER        = $04;
ERR_INVALID_IOCTL_VALUE   = $05;
ERR_INVALID_FLAGS         = $06;
ERR_FAILED                = $07;
ERR_DEVICE_NOT_CONNECTED  = $08;
ERR_TIMEOUT               = $09;
ERR_INVALID_MSG           = $0A;
ERR_INVALID_TIME_INTERVAL = $0B;
ERR_EXCEEDED_LIMIT        = $0C;
ERR_INVALID_MSG_ID        = $0D;
ERR_DEVICE_IN_USE         = $0E;
ERR_INVALID_IOCTL_ID      = $0F;
ERR_BUFFER_EMPTY          = $10;
ERR_BUFFER_FULL           = $11;
ERR_BUFFER_OVERFLOW       = $12;
ERR_PIN_INVALID           = $13;
ERR_CHANNEL_IN_USE        = $14;
ERR_MSG_PROTOCOL_ID       = $15;
ERR_INVALID_FILTER_ID     = $16;
ERR_NO_FLOW_CONTROL       = $17;
ERR_NOT_UNIQUE            = $18;
ERR_INVALID_BAUDRATE      = $19;
ERR_INVALID_DEVICE_ID     = $1A;

// OP2.0 Tactrix specific
ERR_OEM_VOLTAGE_TOO_LOW   = $78; // OP2.0: the requested output voltage is lower than the OP2.0 capabilities
ERR_OEM_VOLTAGE_TOO_HIGH  = $77; // OP2.0: the requested output voltage is higher than the OP2.0 capabilities


aErrorsDescriptions: array[0..28] of TErrorDescription=(
  (id:ERR_SUCCESS; Description:'ERR_SUCCESS'),
  (id:ERR_NOT_SUPPORTED; Description:'ERR_NOT_SUPPORTED'),
  (id:ERR_INVALID_CHANNEL_ID; Description:'ERR_INVALID_CHANNEL_ID'),
  (id:ERR_INVALID_PROTOCOL_ID; Description:'ERR_INVALID_PROTOCOL_ID'),
  (id:ERR_NULL_PARAMETER; Description:'ERR_NULL_PARAMETER'),
  (id:ERR_INVALID_IOCTL_VALUE; Description:'ERR_INVALID_IOCTL_VALUE'),
  (id:ERR_INVALID_FLAGS; Description:'ERR_INVALID_FLAGS'),
  (id:ERR_FAILED; Description:'ERR_FAILED'),
  (id:ERR_DEVICE_NOT_CONNECTED; Description:'OBD Device not connected'),
  (id:ERR_TIMEOUT; Description:'ERR_TIMEOUT'),
  (id:ERR_INVALID_MSG; Description:'ERR_INVALID_MSG'),
  (id:ERR_INVALID_TIME_INTERVAL; Description:'ERR_INVALID_TIME_INTERVAL'),
  (id:ERR_EXCEEDED_LIMIT; Description:'ERR_EXCEEDED_LIMIT'),
  (id:ERR_INVALID_MSG_ID; Description:'ERR_INVALID_MSG_ID'),
  (id:ERR_DEVICE_IN_USE; Description:'ERR_DEVICE_IN_USE'),
  (id:ERR_INVALID_IOCTL_ID; Description:'ERR_INVALID_IOCTL_ID'),
  (id:ERR_BUFFER_EMPTY; Description:'ERR_BUFFER_EMPTY'),
  (id:ERR_BUFFER_FULL; Description:'ERR_BUFFER_FULL'),
  (id:ERR_BUFFER_OVERFLOW; Description:'ERR_BUFFER_OVERFLOW'),
  (id:ERR_PIN_INVALID; Description:'ERR_PIN_INVALID'),
  (id:ERR_CHANNEL_IN_USE; Description:'ERR_CHANNEL_IN_USE'),
  (id:ERR_MSG_PROTOCOL_ID; Description:'ERR_MSG_PROTOCOL_ID'),
  (id:ERR_INVALID_FILTER_ID; Description:'ERR_INVALID_FILTER_ID'),
  (id:ERR_NO_FLOW_CONTROL; Description:'ERR_NO_FLOW_CONTROL'),
  (id:ERR_NOT_UNIQUE; Description:'ERR_NOT_UNIQUE'),
  (id:ERR_INVALID_BAUDRATE; Description:'ERR_INVALID_BAUDRATE'),
  (id:ERR_INVALID_DEVICE_ID; Description:'ERR_INVALID_DEVICE_ID'),
  (id:ERR_OEM_VOLTAGE_TOO_LOW; Description:'ERR_OEM_VOLTAGE_TOO_LOW'),
  (id:ERR_OEM_VOLTAGE_TOO_HIGH; Description:'ERR_OEM_VOLTAGE_TOO_HIGH')
);

/////////////////////////
// PassThruConnect flags
/////////////////////////
CAN_29BIT_ID        = $00000100;
ISO9141_NO_CHECKSUM = $00000200;
CAN_ID_BOTH         = $00000800;
ISO9141_K_LINE_ONLY = $00001000;
SNIFF_MODE          = $10000000; // OP2.0: listens to a bus (e.g. CAN) without acknowledging

//////////////////
// RxStatus flags
//////////////////
TX_MSG_TYPE            = $00000001;
START_OF_MESSAGE       = $00000002;
ISO15765_FIRST_FRAME   = $00000002;
RX_BREAK               = $00000004;
TX_DONE                = $00000008;
ISO15765_PADDING_ERROR = $00000010;
ISO15765_EXT_ADDR      = $00000080;
ISO15765_ADDR_TYPE     = $00000080;

//////////////////
// TxStatus flags
//////////////////
ISO15765_FRAME_PAD = $00000040;
WAIT_P3_MIN_ONLY   = $00000200;
SW_CAN_HV_TX       = $00000400; // OP2.0: Not supported
SCI_MODE           = $00400000; // OP2.0: Not supported
SCI_TX_VOLTAGE     = $00800000; // OP2.0: Not supported

////////////////
// Filter types
////////////////
PASS_FILTER         = $00000001;
BLOCK_FILTER        = $00000002;
FLOW_CONTROL_FILTER = $00000003;

/////////////////
// Message record
/////////////////
PASSTHRU_MSG_DATA_SIZE = 4128;

type TPassthruMsg=packed record
    ProtocolID: Cardinal;
    RxStatus: Cardinal;
    TxFlags: Cardinal;
    Timestamp: Cardinal;
    DataSize: Cardinal;
    ExtraDataIndex: Cardinal;
  Data: array[0..PASSTHRU_MSG_DATA_SIZE-1] of byte;
end;

////////////////
// IOCTL records
////////////////
type TSCONFIG=record
  Parameter: Cardinal;
  Value: Cardinal;
end;

type TSCONFIG_LIST=record
  NumOfParams: Cardinal;
  ConfigPtr: Pointer;
end;

type TSBYTE_ARRAY=record
  NumOfBytes: Cardinal;
  BytePtr: array of byte;
end;


implementation

end.
