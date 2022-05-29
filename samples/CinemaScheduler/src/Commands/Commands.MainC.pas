﻿unit Commands.MainC;

interface

uses
  System.SysUtils,
  Spring.Container.Common,
  {-}
  Commands.Main,
  Utils.Logger,
  Services.DataConnection;

type
  TMainCommand = class(TInterfacedObject, IMainCommand)
  private
    fReady: boolean;
    fLogger: ILogger;
    fDataConnection: IDataConnection;
  public
    [Inject]
    constructor Create(const aLogger: ILogger;
      const aDataConnection: IDataConnection);
    procedure Run(const date: TDateTime);
  end;

implementation

uses
  Spring;

constructor TMainCommand.Create(const aLogger: ILogger;
  const aDataConnection: IDataConnection);
begin
  fLogger := aLogger;
  fDataConnection := aDataConnection;
  fReady := True;
end;

procedure TMainCommand.Run(const date: TDateTime);
begin
  fDataConnection.Connect('host=locahost;database=cinema');
end;

end.
