unit Services.DataConnectionC;

interface

uses
  Spring.Collections,
  Services.DataConnection,
  Model.Cinema;

type
  TDataConnection = class(TInterfacedObject, IDataConnection)
  private
    fMovies: IList<TMovie>;
    fShows: IList<TShow>;
    fConnected: boolean;
    fConnectionStr: string;
    procedure GuardConnected;
  public
    constructor Create;
    procedure Connect(const aConnectionStr: string);
    function GetMovies: IEnumerable<TMovie>;
    function GetShows: IEnumerable<TShow>;
    procedure AddTicket(const aShow: TShow; aSeat: TSeat); overload;
    procedure AddTicket(const aShow: TShow;
      const aSeats: TArray<TSeat>); overload;
  end;

implementation

constructor TDataConnection.Create;
begin
  fConnected := false;
end;

procedure TDataConnection.Connect(const aConnectionStr: string);
begin
  fConnectionStr := aConnectionStr;
  fMovies := TCollections.CreateObjectList<TMovie>();
  fShows := TCollections.CreateObjectList<TShow>();
end;

procedure TDataConnection.AddTicket(const aShow: TShow; aSeat: TSeat);
begin
  GuardConnected;
end;

procedure TDataConnection.AddTicket(const aShow: TShow;
  const aSeats: TArray<TSeat>);
begin
  GuardConnected;
end;

function TDataConnection.GetMovies: IEnumerable<TMovie>;
begin
  GuardConnected;
  Result := fMovies;
end;

function TDataConnection.GetShows: IEnumerable<TShow>;
begin
  GuardConnected;
  Result := fShows;
end;

procedure TDataConnection.GuardConnected;
begin

end;

end.
