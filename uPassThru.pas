unit uPassThru;

interface
uses Windows, SysUtils, uPassThruConst;
const
  DLL_NAME='op20pt32.dll';
  DLL_func_list:array[0..13] of PAnsiChar=(
    'PassThruOpen',
    'PassThruClose',
    'PassThruConnect',
    'PassThruDisconnect',
    'PassThruReadMsgs',
    'PassThruWriteMsgs',
    'PassThruStartPeriodicMsg',
    'PassThruStopPeriodicMsg',
    'PassThruStartMsgFilter',
    'PassThruStopMsgFilter',
    'PassThruSetProgrammingVoltage',
    'PassThruReadVersion',
    'PassThruGetLastError',
    'PassThruIoctl'
  );

type TPassThruOpen = function(name: PAnsiChar; var DeviceID: Cardinal):Integer; stdcall;
type TPassThruClose = function(DeviceID: Cardinal):Integer; stdcall;
type TPassThruConnect = function(DeviceID: Cardinal; ProtocolID: Cardinal; Flags: Cardinal; Baudrate: Cardinal; var ChannelID: Cardinal):Integer; stdcall;
type TPassThruDisconnect = function(ChannelID: Cardinal):Integer; stdcall;
type TPassThruReadMsgs = function(ChannelID: Cardinal; var Msg: TPassthruMsg; var NumMsgs: Cardinal; Timeout: Cardinal):Integer; stdcall;
type TPassThruWriteMsgs = function(ChannelID: Cardinal; Msg: Pointer; NumMsgs: Pointer; Timeout: Cardinal):Integer; stdcall;
type TPassThruStartPeriodicMsg = function(ChannelID: Cardinal; Msg: Pointer; var MsgId: Cardinal; TimeInterval: Cardinal):Integer; stdcall;
type TPassThruStopPeriodicMsg = function(ChannelID: Cardinal; MsgId: Cardinal):Integer; stdcall;
type TPassThruStartMsgFilter = function(ChannelID: Cardinal; FilterType: Cardinal; MaskMsg: Pointer; PatternMsg: Pointer; FlowControlMsg: Pointer; var MsgId: Cardinal):Integer; stdcall;
type TPassThruStopMsgFilter = function(ChannelID: Cardinal; MsgId: Cardinal):Integer; stdcall;
type TPassThruSetProgrammingVoltage = function(DeviceID: Cardinal; Pin: Cardinal; Voltage: Cardinal):Integer; stdcall;
type TPassThruReadVersion = function(DeviceID: Cardinal; sApiVersion: PAnsiChar; sDllVersion: PAnsiChar; sFirmwareVersion: PAnsiChar):Integer; stdcall;
type TPassThruGetLastError = function(pErrorDescription: PAnsiChar):Integer; stdcall;
type TPassThruIoctl = function(ChannelID: Cardinal; IoctlID: Cardinal; const pInput: Pointer; pOutput: Pointer):Integer; stdcall;

type
  TJ2534=class
public
  constructor Create();
  destructor Destroy(); override;
  procedure SetDLLName(name: string);
  function GetDLLName():string;
  function Init(): boolean;
  function GetLastError(): string;
  function GetErrorDescription(id: byte): string;
  function PassThruOpen(name: string; var DeviceID: Cardinal): Integer;
  function PassThruClose(DeviceID: Cardinal): Integer;
  function PassThruConnect(DeviceID: Cardinal; ProtocolID: Cardinal; Flags: Cardinal; Baudrate: Cardinal; var ChannelID: Cardinal): Integer;
  function PassThruDisconnect(ChannelID: Cardinal):Integer;
  function PassThruReadMsgs(ChannelID: Cardinal; var Msg: TPassthruMsg; var NumMsgs: Cardinal; Timeout: Cardinal):Integer;
  function PassThruWriteMsgs(ChannelID: Cardinal; Msg: TPassthruMsg; NumMsgs: Cardinal; Timeout: Cardinal): Integer;
  function PassThruStartPeriodicMsg(ChannelID: Cardinal; Msg: TPassthruMsg; var MsgId: cardinal; TimeInterval: Cardinal): Integer;
  function PassThruStopPeriodicMsg(ChannelID: Cardinal; MsgId: Cardinal):Integer;
  function PassThruStartMsgFilter(ChannelID: Cardinal; FilterType: Cardinal; MaskMsg: Pointer; PatternMsg: Pointer; FlowControlMsg: Pointer; var MsgId: Cardinal):Integer;
  function PassThruStopMsgFilter(ChannelID: Cardinal; MsgId: Cardinal):Integer;
  function PassThruSetProgrammingVoltage(DeviceID: Cardinal; Pin: Cardinal; Voltage: Cardinal):Integer;
  function PassThruReadVersion(var sApiVersion: PAnsiChar; var sDllVersion: PAnsiChar; var sFirmwareVersion: PAnsiChar; DeviceID: Cardinal):Integer;
  function PassThruIoctl(ChannelID: Cardinal; IoctlID: Cardinal; pInput: Pointer; pOutput: Pointer):Integer;
  function PassThruGetLastError(var pErrorDescription: PAnsiChar): Integer;
private
  LastError: string;
  DebugMode: boolean;
  DLLName: string;
  hDLL: THandle;
  function ÑheckDLL(): boolean;
  function LoadJ2534DLL(strDLL: string): boolean;
  function CheckFuncPointers(): boolean;
  procedure DbgPrint(str: string);
end;

implementation

function TJ2534.ÑheckDLL: boolean;
begin
  if hDLL=0 then LoadJ2534DLL(DLLName);
  Result:=(hDLL<>0);
end;

constructor TJ2534.Create;
begin
  hDLL:=0;
  DebugMode:=false;
  DLLName:=DLL_NAME;
end;

procedure TJ2534.DbgPrint(str: string);
begin
// not implemented
end;

destructor TJ2534.Destroy;
begin
  if hDLL<>0 then FreeLibrary(hDLL);
  inherited;
end;

function TJ2534.GetDLLName: string;
begin
  Result:=Self.DLLName;
end;

function TJ2534.GetErrorDescription(id: byte): string;
var
  i: integer;
begin
  Result:='Error 0x'+IntToHex(id,2);
  for i:=0 to High(aErrorsDescriptions) do
    begin
      if aErrorsDescriptions[i].id=id then
        begin
          Result:=aErrorsDescriptions[i].Description;
        end;
    end;
end;

function TJ2534.GetLastError: string;
begin
  Result:=LastError;
end;

function TJ2534.CheckFuncPointers: boolean;
var
  i: integer;
  h: Pointer;
begin
  Result:=false;
  if hDLL=0 then Exit;
  for i := 0 to High(DLL_func_list) do
    begin
      h:=GetProcAddress(hDLL,DLL_func_list[i]);
      if h=nil then Exit;
    end;
  Result:=true;
end;

function TJ2534.Init: boolean;
begin
  Result:=ÑheckDLL();
end;

function TJ2534.LoadJ2534DLL(strDLL: string): boolean;
var
  dwError: Integer;
begin
  if strDLL='' then
    begin
      LastError:='NULL string pointer to J2534 DLL location.';
      Result:=false;
      Exit;
    end;
  hDLL:=LoadLibrary(PWideChar(strDLL));
  if hDLL=0 then
    begin
      dwError := Windows.GetLastError();
      LastError:='error loading J2534 DLL '+IntToStr(dwError);
      Result:=false;
      Exit;
    end;
  if CheckFuncPointers()=false then
    begin
      FreeLibrary(hDLL);
      hDLL:=0;
      LastError:='error loading J2534 DLL function pointers';
      Result:=false;
      Exit;
    end;
  DbgPrint('DLL loaded successfully');
  Result:=true;
end;

function TJ2534.PassThruClose(DeviceID: Cardinal): Integer;
var
  Func: TPassThruClose;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  DbgPrint(format('PassThruClose(%d)',[DeviceID]));

  Func:=GetProcAddress(hDLL,'PassThruClose');
  Result:=Func(DeviceID);
  DbgPrint(Format('PassThruClose returned result %d (%s)',[Result,GetErrorDescription(Result)]));
end;

function TJ2534.PassThruConnect(DeviceID, ProtocolID, Flags, Baudrate: Cardinal; var ChannelID: Cardinal): Integer;
var
  Func: TPassThruConnect;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  DbgPrint(Format('PassThruConnect(DeviceID=%u,ProtocolID=%u,Flags=%08X,Baudrate=%u,pChannelID=%d)',[DeviceID,ProtocolID,Flags,Baudrate,ChannelID]));
  Func:=GetProcAddress(hDLL,'PassThruConnect');
  Result:=Func(DeviceID,ProtocolID,Flags,Baudrate,ChannelID);
  DbgPrint(Format('PassThruConnect returned result %u (%s) and ChannelID %u',[Result, GetErrorDescription(Result), ChannelID]));
end;

function TJ2534.PassThruDisconnect(ChannelID: Cardinal): Integer;
var
  Func: TPassThruDisconnect;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  DbgPrint(Format('PassThruDisconnect(ChannelID=%u)',[ChannelID]));
  Func:=GetProcAddress(hDLL,'PassThruDisconnect');
  Result:=Func(ChannelID);
  DbgPrint(Format('PassThruDisconnect returned result %d (%s)',[Result,GetErrorDescription(Result)]));
end;

function TJ2534.PassThruGetLastError(var pErrorDescription: PAnsiChar): Integer;
var
  Func: TPassThruGetLastError;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  pErrorDescription:=AnsiStrAlloc(255);
  Func:=GetProcAddress(hDLL,'PassThruGetLastError');
  Result:=Func(pErrorDescription);
  DbgPrint(Format('PassThruGetLastError returned result %d and ErrorDescription [%s]',[Result,pErrorDescription]));
end;

function TJ2534.PassThruIoctl(ChannelID, IoctlID: Cardinal; pInput: Pointer; pOutput: Pointer): Integer;
var
  Func: TPassThruIoctl;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  DbgPrint(Format('PassThruIoctl ChannelID=%d IoctlID=%d',[ChannelID, IoctlID]));

  Func:=GetProcAddress(hDLL,'PassThruIoctl');
  Result:=Func(ChannelID,IoctlID,pInput,pOutput);
  DbgPrint(Format('PassThruIoctl returned result %d (%s)',[Result,GetErrorDescription(Result)]));
end;

function TJ2534.PassThruOpen(name: string; var DeviceID: Cardinal): Integer;
var
  Func: TPassThruOpen;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  DbgPrint('PassThruOpen(name='+name+',pDeviceID='+IntToHex(DeviceID,8)+')');

  Func:=GetProcAddress(hDLL,'PassThruOpen');
  Result:=Func(PAnsiChar(AnsiString(name)),DeviceID);
  DbgPrint(Format('PassThruOpen returned result %d (%s) and DeviceID %x',[Result,GetErrorDescription(Result),DeviceID]));
end;

function TJ2534.PassThruReadMsgs(ChannelID: Cardinal; var Msg: TPassthruMsg; var NumMsgs: Cardinal; Timeout: Cardinal): Integer;
var
  Func: TPassThruReadMsgs;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  DbgPrint(Format('PassThruReadMsgs(ChannelID=%u,Msg.Protocol=%08X,pNumMsgs=%u,Timeout=%u)',[ChannelID, Msg.ProtocolID, NumMsgs, Timeout]));
  Func:=GetProcAddress(hDLL,'PassThruReadMsgs');
  Result:=Func(ChannelID, Msg, NumMsgs,Timeout);
  DbgPrint(Format('PassThruReadMsgs returned result %d (%s)  flags:%08X',[Result,GetErrorDescription(Result),Msg.RxStatus]));
end;

function TJ2534.PassThruReadVersion(var sApiVersion, sDllVersion, sFirmwareVersion: PAnsiChar; DeviceID: Cardinal): Integer;
var
  Func: TPassThruReadVersion;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  sApiVersion:=AnsiStrAlloc(50);
  sDllVersion:=AnsiStrAlloc(50);
  sFirmwareVersion:=AnsiStrAlloc(50);
  Func:=GetProcAddress(hDLL,'PassThruReadVersion');
  Result:=Func(DeviceID,sFirmwareVersion,sDllVersion,sApiVersion);
  DbgPrint(Format('PassThruReadVersion returned result %d and FirmwareVersion [%s], DllVersion [%s], ApiVersion [%s]',[Result,sFirmwareVersion,sDllVersion,sApiVersion]));
end;

function TJ2534.PassThruSetProgrammingVoltage(DeviceID, Pin, Voltage: Cardinal): Integer;
var
  Func: TPassThruSetProgrammingVoltage;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  DbgPrint(Format('PassThruSetProgrammingVoltage(DeviceID=%u,Pin=%u,Voltage=%u)',[DeviceID,Pin,Voltage]));
  Func:=GetProcAddress(hDLL,'PassThruSetProgrammingVoltage');

  Result:=Func(DeviceID,Pin,Voltage);
  DbgPrint(Format('PassThruSetProgrammingVoltage returned result %d (%s)',[Result,GetErrorDescription(Result)]));
end;

function TJ2534.PassThruStartMsgFilter(ChannelID, FilterType: Cardinal; MaskMsg, PatternMsg, FlowControlMsg: Pointer; var MsgId: Cardinal): Integer;
var
  Func: TPassThruStartMsgFilter;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  Func:=GetProcAddress(hDLL,'PassThruStartMsgFilter');
  Result:=Func(ChannelID,FilterType,MaskMsg,PatternMsg,FlowControlMsg,MsgID);
  DbgPrint(Format('PassThruStartMsgFilter returned result %d (%s) and MsgID %u',[Result,GetErrorDescription(Result),MsgID]));
end;

function TJ2534.PassThruStopMsgFilter(ChannelID, MsgId: Cardinal): Integer;
var
  Func: TPassThruStopMsgFilter;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  DbgPrint(Format('PassThruStopMsgFilter(ChannelID=%u,pMsgID=@%08X)', [ChannelID,MsgID]));
  Func:=GetProcAddress(hDLL,'PassThruStopMsgFilter');
  Result:=Func(ChannelID,MsgID);
  DbgPrint(Format('PassThruStartMsgFilter returned result %d (%s)',[Result,GetErrorDescription(Result)]));
end;

function TJ2534.PassThruStartPeriodicMsg(ChannelID: Cardinal; Msg: TPassthruMsg; var MsgId: cardinal; TimeInterval: Cardinal): Integer;
var
  Func: TPassThruStartPeriodicMsg;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  Func:=GetProcAddress(hDLL,'PassThruStartPeriodicMsg');

  Result:=Func(ChannelID,@Msg,MsgID,TimeInterval);
  DbgPrint(Format('PassThruStartPeriodicMsg returned result %d ($s)',[Result,GetErrorDescription(Result)]));
end;

function TJ2534.PassThruStopPeriodicMsg(ChannelID, MsgId: Cardinal): Integer;
var
  Func: TPassThruStopPeriodicMsg;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  Func:=GetProcAddress(hDLL,'PassThruStopPeriodicMsg');

  Result:=Func(ChannelID,MsgID);
  DbgPrint(Format('PassThruStopPeriodicMsg returned result %d (%s)',[Result,GetErrorDescription(Result)]));
end;

function TJ2534.PassThruWriteMsgs(ChannelID: Cardinal; Msg: TPassthruMsg; NumMsgs, Timeout: Cardinal): Integer;
var
  Func: TPassThruWriteMsgs;
begin
  Result:=STATUS_NOERROR;
  if ÑheckDLL()=false then
    begin
      Result:=ERR_DEVICE_NOT_CONNECTED;
      Exit;
    end;
  DbgPrint(Format('PassThruWriteMsgs(ChannelID=%u,Msg.Protocol=%08X,NumMsgs=%u,Timeout=%u)',[ChannelID, Msg.ProtocolID,NumMsgs,Timeout]));
  Func:=GetProcAddress(hDLL,'PassThruWriteMsgs');

  Result:=Func(ChannelID,@Msg,@NumMsgs,Timeout);
  DbgPrint(Format('PassThruWriteMsgs returned result %u (%s)',[Result,GetErrorDescription(Result)]));
end;

procedure TJ2534.SetDLLName(name: string);
begin
  if DLLName<>name then
    begin
      FreeLibrary(hDLL);
      hDLL:=0;
    end;
  DLLName:=name;
end;

end.

