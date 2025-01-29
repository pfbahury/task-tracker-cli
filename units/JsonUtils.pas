unit JsonUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fpjson, JSONParser;


procedure LoadJson(FileName: string; out JArray: TJSONArray);
procedure AddTask(Task: string; FileName: string);
procedure ListTasks(FileName: string);
procedure UpdateTask(FileName: string; TaskId: integer; Task: String);
procedure UpdateTaskStatus(FileName: string; TaskId: integer; Status: string);
procedure DeleteTask(FileName: string; TaskId: integer);

implementation

procedure SaveJson(FileName: String; JArray: TJSONArray);
var
  JString: TStringList;
begin
  JString := TStringList.Create;
  try
    JString.Text := JArray.AsJSON;
    JString.SaveToFile(FileName);
  except
    on E: Exception do
    begin
      WriteLn('Failure when saving JSON: ', E.Message);
    end;
  end;
  JString.Free;
end;

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
     //WriteLn('File not found, creating a new JSON file...');
     CreateJson(FileName);
     LoadJson(FileName, JArray)
   end;
end;

procedure AddTask(Task: string; FileName: string);
var
  JArray: TJSONArray;
  JObject: TJSONObject;
begin
  JArray := TJSONArray.Create;
  LoadJson(FileName, JArray);
  try
    JObject := TJSONObject.Create;

    JObject.Add('id', JArray.count +1);
    JObject.Add('description', Task);
    JObject.Add('status', 'todo');
    JObject.Add('createdAt', DateTimeToStr(Now));
    JObject.Add('updatedAt', DateTimeToStr(Now));

    JArray.Add(JObject);

    SaveJson(FileName, JArray);
    WriteLn('Test added successfully');

  finally
    JArray.Free;
  end;
end;

procedure ListTasks(FileName: string);
var
  JArray: TJSONArray;
  JObject: TJSONObject;
  i: integer;
begin
    LoadJson(FileName, JArray);
    for i := 0 to JArray.Count - 1 do
    begin
      JObject := JArray.Objects[i];
      WriteLn('Id: ', JObject.Integers['id']);
      WriteLn('Task: ', JObject.Strings['description']);
      WriteLn('Status: ', JObject.Strings['status']);
      WriteLn('Created at: ', JObject.Strings['createdAt']);
      WriteLn('Updated at: ', JObject.Strings['updatedAt']);
      WriteLn('-------------------------------------------------------');
    end;
end;

procedure UpdateTask(FileName: string; TaskId: integer; Task: String);
var
  JArray: TJSONArray;
  JObject: TJSonObject;
  i: integer;
  TaskFound: boolean;
begin
   TaskFound := False;
   LoadJson(FileName, JArray);
   for i := 0 to JArray.Count - 1 do
   begin
     JObject := JArray.Objects[i];
     if JObject.Integers['id'] = TaskId then
     begin
        JObject.Strings['description'] := Task;
        JObject.Strings['updatedAt'] := DateTimeToStr(Now);
        SaveJson(FileName, JArray);
        WriteLn('Task Updated Successfully');
        TaskFound := True;
        Break;
     end;
   end;

   if not TaskFound then
   begin
      WriteLn('Task not found');
   end;
end;

procedure UpdateTaskStatus(FileName: string; TaskId: integer; Status: string);
var
  JArray : TJSONArray;
  JObject : TJSONObject;
  i: integer;
  TaskFound: boolean;
begin
  TaskFound := False;
  LoadJson(FileName, JArray);
  for i := 0 to JArray.Count - 1 do
  begin
    JObject := JArray.Objects[i];
    if JObject.Integers['id'] = TaskId then
    begin
       JObject.Strings['status'] := Status;
       JObject.Strings['updatedAt'] := DateTimeToStr(Now);
       SaveJson(FileName, JArray);
       WriteLn('Task status set to: ', status);
       TaskFound := True;
    end;
  end;

  if not TaskFound then
  begin
     WriteLn('Task not found');
  end;
end;

procedure DeleteTask(FileName: string; TaskId: integer);
var
  JArray: TJSONArray;
  JObject : TJSONObject;
  i: integer;
  TaskFound : Boolean;
begin
  TaskFound:=False;
  LoadJson(FileName,JArray);
  for i := 0 to JArray.Count - 1 do
  begin
    JObject := JArray.Objects[i];
    if JObject.Integers['id'] = TaskId then
    begin
       JArray.Delete(i);
       WriteLn('Task deleted successfully.');
       //SaveJson(FileName,JArray);
       TaskFound:=True;
    end;
  end;

  if not TaskFound then
  begin
    WriteLn('Task not found');
    Exit;
  end;

  for i:=0 to JArray.Count - 1 do
  begin
    JObject := JArray.Objects[i];
    JObject.Integers['id'] := i + 1;
  end;
  SaveJson(FileName, JArray);
end;



end.

