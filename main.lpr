program main;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
    Classes
  , SysUtils
  //, fpjson
  //, JSONParser
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
  WriteLn('3 - Update task');
  WriteLn('4 - Update task status');
  WriteLn('.exit - Exit the program');
  Writeln('---------------------------------------------------------');
  Write('Input: ');
end;

function getStatus():string;
var
  StatusInput: string;
  IsValid: boolean;
begin
  IsValid := false;
  WriteLn('Choose a new status: ');
  WriteLn('1 - todo');
  WriteLn('2 - in-progress');
  WriteLn('3 - done');
  Write('Input: ');
  repeat
     ReadLn(StatusInput);
     case StatusInput of
       '1':
         begin
           Result := 'todo';
           IsValid := True;
         end;
       '2':
         begin
           Result := 'in-progress';
           IsValid := True;
         end;
       '3':
         begin
           Result := 'done';
           IsValid := True;
         end;
     else
      begin
        Write('Invalid status, Try Again: ');
      end;
     end;
  until IsValid ;

end;

var
  input, Task, Status: string;
  TaskId : Integer;

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
       '3':
         begin
           ClrScr;
           Write('Updated task id: ');
           ReadLn(TaskId);
           Write('Updated task description: ');
           ReadLn(Task);
           UpdateTask(FILE_NAME, TaskId, Task);
           WriteLn('Returning to main menu...');
           Sleep(1500);
           RenderMenu();
         end;
       '4':
         begin
           ClrScr;
           Write('Updated task id: ');
           ReadLn(TaskId);
           Status:=getStatus();
           UpdateTaskStatus(FILE_NAME, TaskId, Status);
           WriteLn('Returning to main menu...');
           Sleep(2000);
           RenderMenu();
         end;
       '.exit':
         begin
           Write('Bye Bye :)');
           Sleep(750);
         end;
       else
        begin
          Write('Invalid input, try again: ');
        end;
     end;
  until input = '.exit';
end.

