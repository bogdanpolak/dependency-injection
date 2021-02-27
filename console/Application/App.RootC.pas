unit App.RootC;

interface

uses
  System.Classes,
  System.SysUtils,
  Spring.Container.Common,
  {-}
  App.Root,
  Commands.Main,
  App.Parameters;

type
  TApplicationRoot = class(TInterfacedObject, IApplicationRoot)
  private
    fMain: IMainCommand;
    fAppParameters: IAppParameters;
  public
    [Inject]
    constructor Create(const aMain: IMainCommand;
      const aAppParameters: IAppParameters);
    procedure Execute;
  end;

implementation

constructor TApplicationRoot.Create(const aMain: IMainCommand;
  const aAppParameters: IAppParameters);
begin
  fMain := aMain;
  fAppParameters := aAppParameters;
  Assert(fMain <> nil);
  Assert(fAppParameters <> nil);
end;

procedure TApplicationRoot.Execute;
begin
  fAppParameters.ValidateParameters;
  case fAppParameters.AppCommand of
    acDefault:
      fMain.Run(Now);
    acShows:
      fMain.Run(fAppParameters.ShowDate);
    acAddTickets:
      ;
    acHelp:
      ;
    acUnknown:
      ;
  end;
  readln;
end;

end.
