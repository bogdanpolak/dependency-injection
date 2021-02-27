unit Model.Cinema;

interface

type
  TPopularity = 1..10;
  
  TMovie = class
  private
    FId: integer;
    FName: string;
    FLaunch: TDateTime;
    FPopularity: TPopularity;
  public
    property Id: integer read FId write FId;
    property Name: string read FName write FName;
    property Launch: TDateTime read FLaunch write FLaunch;
    property Popularity: TPopularity read FPopularity write FPopularity;
  end;

  TShow = class
  private
    FId: integer;
    FMovie: TMovie;
    FStart: TDateTime;
  public
    property Id: integer read FId write FId;
    property Movie: TMovie read FMovie write FMovie;
    property Start: TDateTime read FStart write FStart;
  end;

  TSeat = class
  private
    FShow: TShow;
  public
    property Show: TShow read FShow write FShow;
  end;

implementation

end.
