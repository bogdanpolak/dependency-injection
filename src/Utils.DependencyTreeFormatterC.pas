unit Utils.DependencyTreeFormatterC;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TDependencyTreeFormatter = class(TObject)
  public
    class function Format(const aTree: String): String;
  end;

implementation

{ TDependencyTreeFormatter }

class function TDependencyTreeFormatter.Format(const aTree: String): String;
var
  idx, start, level: Integer;
  ch: Char;
  line: String;
  sl: TStringList;
begin
  sl := TStringList.Create();
  try
  sl.Add('Application Root Dependency Tree:');
  sl.Add('----------------------------------------------');
    start := 0;
    level := 0;
    for idx := 0 to aTree.Length - 1 do
    begin
      ch := aTree.Chars[idx];
      if (idx = aTree.Length - 1) or (CharInSet(ch, ['{', '}', ','])) then
      begin
        if (start < idx) then
        begin
          line := StringOfChar(' ', 4 * level) + aTree.Substring(start,
            idx - start);
          sl.Add(line);
        end;
        start := idx + 1;
      end;
      case ch of
        '{':
          inc(level);
        '}':
          dec(level);
      end;
    end;
    Result := sl.Text + '----------------------------------------------';
  finally
    sl.Free;
  end;
end;

end.
