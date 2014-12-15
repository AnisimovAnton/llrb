program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  UnLLRB in 'UnLLRB.pas';

var
  llrb: TLeftLeaningRedBlackTree;
begin
  llrb := TLLRB.Create;
  llrb.Free;
end.
