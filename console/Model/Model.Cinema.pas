unit Model.Cinema;

interface

type
  TPopularity = 1 .. 10;

  TMovie = class
  private
    FId: integer;
    FName: string;
    FLaunch: TDateTime;
    FPopularity: TPopularity;
    FLength: integer;
  public
    constructor New(aLaunch: TDateTime; aLength: integer;
      aPopularity: TPopularity; const aName: string);
    property Id: integer read FId write FId;
    property Name: string read FName write FName;
    property Length: integer read FLength write FLength;
    property Launch: TDateTime read FLaunch write FLaunch;
    property Popularity: TPopularity read FPopularity write FPopularity;
  end;

  TRoom = class
  private
    FId: integer;
    FName: string;
    FRows: integer;
    FSeats: integer;
  public
    constructor New(aRows: integer; aSeats: integer; const aName: string);
    property Id: integer read FId write FId;
    property Name: string read FName write FName;
    property Rows: integer read FRows write FRows;
    property Seats: integer read FSeats write FSeats;
  end;

  TShow = class
  private
    FId: integer;
    FMovie: TMovie;
    FStart: TDateTime;
    FRoom: TRoom;
  public
    constructor New(aRoom:TRoom; aMovie:TMovie; aStart:TDateTime);
    property Id: integer read FId write FId;
    property Movie: TMovie read FMovie write FMovie;
    property Room: TRoom read FRoom write FRoom;
    property Start: TDateTime read FStart write FStart;
  end;

  TSeat = class
  private
    FShow: TShow;
  public
    property Show: TShow read FShow write FShow;
  end;

implementation

var
  aNextMovieId: integer = 1;
  aNextRoomId: integer = 1;
  aNextShowId: integer = 1;

constructor TMovie.New(aLaunch: TDateTime; aLength: integer;
  aPopularity: TPopularity; const aName: string);
begin
  Id := aNextMovieId;
  Launch := aLaunch;
  Length := aLength;
  Popularity := aPopularity;
  Name := aName;
  inc(aNextMovieId);
end;


constructor TRoom.New(aRows, aSeats: integer; const aName: string);
begin
  Id := aNextRoomId;
  Name := aName;
  Rows := aRows;
  Seats := aSeats;
  inc(aNextRoomId);
end;

constructor TShow.New(aRoom: TRoom; aMovie: TMovie; aStart: TDateTime);
begin
  Id := aNextShowId;
  Movie := aMovie;
  Room := aRoom;
  Start := aStart;
  inc(aNextShowId);
end;

end.
