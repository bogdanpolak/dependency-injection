unit WeatherFromTimeAndDate;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Net.HttpClient;

type
  TWeatherFromTimeAndDate = class
    class function Get(const aLocation: string): string;
  end;

implementation

class function TWeatherFromTimeAndDate.Get(const aLocation: string): string;
var
  HttpClient: THTTPClient;
  url: string;
  content: string;
  idxQuickLook: Integer;
  idx1: Integer;
  idx2: Integer;
  temperature: string;
  info: string;
begin
  // -----------
  // <div id=qlook class=bk-focus__qlook>
  // <div class=h1>Now</div>
  // <img id=cur-weather class=mtt title="Sunny." src="//c.tadst.com/gfx/w/svg/wt-1.svg" width=80 height=80>
  // <div class=h2>28&nbsp;°C</div>
  // -----------
  HttpClient := THTTPClient.Create();
  try
    url := Format('https://www.timeanddate.com/weather/%s', [aLocation]);
    content := HttpClient.Get(url).ContentAsString();
    idxQuickLook := content.IndexOf('<div id=qlook');
    // <div class="h2">26&nbsp;°C</div>
    idx1 := content.IndexOf('<div class=h2>', idxQuickLook);
    idx2 := content.IndexOf('</div>', idx1);
    if (idxQuickLook >= 0) and (idx1 > idxQuickLook) and (idx2 > idx1) then
    begin
      temperature := content.Substring(idx1 + 14, idx2 - idx1 - 14)
        .Replace('&nbsp;', ' ');
    end;
    idx1 := content.IndexOf('title="', idxQuickLook);
    idx2 := content.IndexOf('"', idx1 + 8);
    if (idxQuickLook >= 0) and (idx1 > idxQuickLook) and (idx2 > idx1) then
    begin
      info := content.Substring(idx1 + 7, idx2 - idx1 - 7);
    end;
    Result := Format('{"location":"%s", "temperature":"%s", "description":"%s"}',
      [aLocation, temperature, info]);
  finally
    HttpClient.Free;
  end;
end;

end.
