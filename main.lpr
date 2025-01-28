program main;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
    Classes
  , SysUtils
  , fpjson
  , JSONParser
  , JsonUtils
  , crt
  ;

procedure RenderMenu();
begin
  ClrScr;
  Writeln('LAZARUS CLI TASK LIST TRACKER - BY PFBAHURY');
  Writeln('---------------------------------------------------------');
  WriteLn('1 - Add a new task');
  WriteLn('2 - List tasks');
  WriteLn('3 - Update tasks');
  WriteLn('.exit - Exit the program');
  Writeln('---------------------------------------------------------');
  Write('Input: ');
end;

var
  input, Task: string;

const FILE_NAME = 'tasks.json';

begin
  // TODO: Create interface procedure to reaply menu after choosing an option
  RenderMenu();
  Repeat
     Readln(input);
     case input of
       '1':
         begin
           Write('Enter the Task: ');
           ReadLn(Task);
           AddTask(Task,FILE_NAME);
           Sleep(1000);
           RenderMenu();
         end;
       '2':
         begin
           ClrScr;
           ListTasks(FILE_NAME);
           Write('Press enter key to return');
           Readln;
           RenderMenu();
         end;
       '.exit':
         begin
           Write('Bye Bye :)');
           Sleep(500);
         end;
       else
        begin
          Write('Invalid input, try again: ');
        end;
     end;
  until input = '.exit';
end.

