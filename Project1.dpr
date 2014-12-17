program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows,
  UnLLRB in 'UnLLRB.pas';

var
  llrb: TLeftLeaningRedBlackTree;
  i,j: Integer;
  lst: Integers;
begin
  llrb := TLLRB.Create;
//  llrb.insert(5);
//  llrb.insert(4);
//  llrb.insert(8);
//  llrb.insert(1);
//  llrb.insert(3);
//  llrb.insert(2);
//  llrb.insert(2);
//  llrb.insert(5);
//  llrb.insert(9);
//  llrb.insert(0);
//  llrb.insert(4);
//  llrb.insert(6);
//  llrb.insert(7);
//  llrb.insert(8);
//  llrb.insert(5);
//  llrb.insert(5);
//  llrb.insert(1);
//  llrb.delete(1);
  for j := 0 to 100 do
  begin
    Writeln('begin ',j,' ',GetTickCount);
    try
      for i := 0 to 10000000 do
        llrb.insert(i);
    except
      on E: Exception do
        writeln('failed 1: ', E.Message);
    end;
    Writeln('mid ',j,' ',GetTickCount);
    try
      for i := 0 to 10000000 do
        llrb.delete(i);
    except
      on E: Exception do
        writeln('failed 2: ', E.Message);
    end;
    Writeln('end ',j,' ',GetTickCount);
  end;
  llrb.Free;
  Exit;

  llrb.ListAll(lst);
  for i := 0 to Length(lst)-1 do
    write(lst[i],' ');
  writeln('');
  llrb.delete(4);
  llrb.delete(7);
  llrb.delete(5);
  llrb.ListAll(lst);
  for i := 0 to Length(lst)-1 do
    write(lst[i],' ');
  writeln('');
  llrb.Free;
end.
