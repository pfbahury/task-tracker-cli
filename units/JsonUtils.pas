unit JsonUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fpjson, JSONParser;


procedure LoadJson(FileName: string; out JArray: TJSONArray);
procedure AddTask(Task: string; FileName: string);

implementation

procedure CreateJson(FileName: string);
var
  JString: TStringList;
  JArray: TJSONArray;
  JObject: TJSONObject;
begin
   try
     JArray := TJSONArray.Create;
     try
       JObject := TJSONObject.Create;

       JString:= TStringList.Create;
       try
          JString.Text := JArray.AsJSON;

          JString.SaveToFile(FileName);
          WriteLn('JSON File saved successfully');
       finally
         JString.Free;
       end;
     finally
       JArray.Free;
     end;
   except
     on E: Exception do
       Writeln('Failure creating the JSON file: ', E.Message);
   end;
end;

procedure LoadJson(FileName: string; out JArray: TJSONArray);
var
  JData: TJSONData;
  JString: TStringList;
begin
   if FileExists(FileName) then
   begin
      JString := TStringList.Create;
      try
        JString.LoadFromFile(FileName);

        JData := GetJSON(JString.Text);

          if JData.JSONType = jtArray then
          begin
             JArray := TJSONArray(JData);
          end
          else
          begin
            JData.Free;
          end;

      finally
        JString.Free;
      end;
   end
   else
   begin
     WriteLn('File not found, creating a new JSON file...');
     CreateJson(FileName);
     LoadJson(FileName, JArray)
   end;
end;

procedure AddTask(Task: string; FileName: String);
var
  JArray: TJSONArray;
  JObject: TJSONObject;
  JString: TStringList;
begin
  JArray := TJSONArray.Create;
  LoadJson(FileName, JArray);
  try
    JObject := TJSONObject.Create;

    JObject.Add('id', JArray.count +1);
    JObject.Add('task', Task);
    JObject.Add('status', 'todo');

    JArray.Add(JObject);
    JString := TStringList.Create;
    try
      JString.Text := JArray.AsJSON;

      JString.SaveToFile(FileName);
    finally
      JString.Free;
    end;
  finally
    JArray.Free;
  end;
end;
end.

