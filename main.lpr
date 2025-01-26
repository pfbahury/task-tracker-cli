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
  ;


var
  JArray : TJSONArray;

const FILE_NAME = 'tasks.json';

begin
  LoadJson(FILE_NAME,JArray);
  readln;
end.

