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


var
  input, Task: string;


const FILE_NAME = 'tasks.json';

begin
  // TODO: Create interface procedure to reaply menu after chooseing an option
  Writeln('LAZARUS CLI TASK LIST TRACKER - BY PFBAHURY');
  Writeln('---------------------------------------------------------');
  WriteLn('1 - Add a new task');
  WriteLn('2 - List tasks');
  WriteLn('3 - Update tasks');                                         
  Writeln('---------------------------------------------------------');
  Write('Input: ');
  Repeat
     Readln(input);
     case input of
       '1':
         begin
           Write('Enter the Task: ');
           ReadLn(Task);
           AddTask(Task,FILE_NAME);
         end;
       '.exit':
         begin
           Write('Bye Bye :)')
         end;
       else
        begin
          Write('Invalid input, try again');
        end;
     end;
  until input = '.exit';


  readln;
end.

