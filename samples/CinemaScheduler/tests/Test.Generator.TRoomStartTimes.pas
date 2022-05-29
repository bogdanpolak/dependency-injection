unit Test.Generator.TRoomStartTimes;

interface

uses
  System.Math,
  System.SysUtils,
  System.DateUtils,
  Spring.Collections,
  DUnitX.TestFramework,
  Generator.Utils.RoomStartTimes,
  Model.Cinema;

{$M+}

type

  [TestFixture]
  TestGenRoomStartTimes = class
  private
    fRooms: IList<TRoom>;
    fRoomStartTimes: TRoomStartTimes;
    actual: string;
    //
    function Test_TryGetSlot(const aLength: integer): string;
  public
    [Setup]
    procedure Setup;
    [Teardown]
    procedure Teardown;
  published
    procedure TryGetSlot_Fri_SecondMovie();
    procedure TryGetSlot_Fri_ThirdMovie;
    procedure TryGetSlot_Fri_MiscMovies;
    procedure TryGetSlot_Wed_ThirdMovieNotAvailable;
    procedure TryGetSlot_Sat_AfterMidnight;
    procedure TryGetSlot_Sat_AfterMidnightNotAvailable;
  end;

implementation

uses
  Utils.DateTime;

procedure TestGenRoomStartTimes.Setup;
begin
  fRooms := TCollections.CreateObjectList<TRoom>([
    { } TRoom.New(40, 45, 'RoomA'),
    { } TRoom.New(40, 45, 'RoomB')]);
  fRoomStartTimes := TRoomStartTimes.Create(fRooms, [
    { Mon } '0:0-0:0',
    { Tue } '0:0-0:0',
    { Wed } '18:00-20:00',
    { Thu } '18:00-23:00',
    { Fri } '15:00-00:30',
    { Sat } '23:00-03:00',
    { Sun } '0:0-0:0']);
end;

procedure TestGenRoomStartTimes.Teardown;
begin
  fRoomStartTimes.Free;
end;

procedure TestGenRoomStartTimes.TryGetSlot_Fri_SecondMovie();
begin
  fRoomStartTimes.Init(Floor(EncodeDate(2021, 03, 05))); // Friday

  Test_TryGetSlot(90);
  actual := Test_TryGetSlot(90);

  Assert.AreEqual('RoomB 2021-03-05 15:00', actual);
end;

procedure TestGenRoomStartTimes.TryGetSlot_Fri_ThirdMovie();
begin
  fRoomStartTimes.Init(Floor(EncodeDate(2021, 03, 05))); // Friday

  Test_TryGetSlot(90);
  Test_TryGetSlot(90);
  actual := Test_TryGetSlot(90);

  Assert.AreEqual('RoomA 2021-03-05 16:30', actual);
end;

procedure TestGenRoomStartTimes.TryGetSlot_Fri_MiscMovies();
var
  actual1: string;
  actual2: string;
  actual3: string;
  actual4: string;
  actual5: string;
begin
  fRoomStartTimes.Init(Floor(EncodeDate(2021, 03, 05))); // Friday

  actual1 := Test_TryGetSlot(100); // "Room A" 15:00-16:40
  actual2 := Test_TryGetSlot(90); // . "Room B" 15:00-16:30
  actual3 := Test_TryGetSlot(110); // "Room B" 16:30-18:20
  actual4 := Test_TryGetSlot(90); // . "Room A" 16:40-18:10
  actual5 := Test_TryGetSlot(90); // "Room A" 18:10-

  Assert.AreEqual('RoomA 2021-03-05 18:10', actual5);
end;

procedure TestGenRoomStartTimes.TryGetSlot_Wed_ThirdMovieNotAvailable();
begin
  fRoomStartTimes.Init(Floor(EncodeDate(2021, 03, 03))); // Thursday

  Test_TryGetSlot(90);
  Test_TryGetSlot(90);
  actual := Test_TryGetSlot(90);

  Assert.AreEqual('', actual);
end;

procedure TestGenRoomStartTimes.TryGetSlot_Sat_AfterMidnight();
begin
  fRoomStartTimes.Init(Floor(EncodeDate(2021, 03, 06))); // Saturday

  Test_TryGetSlot(90);
  Test_TryGetSlot(90);
  actual := Test_TryGetSlot(90);

  Assert.AreEqual('RoomA 2021-03-07 00:30', actual);
end;

procedure TestGenRoomStartTimes.TryGetSlot_Sat_AfterMidnightNotAvailable();
var
  isAvailable2: Boolean;
  actual1: string;
  actual2: string;
begin
  fRoomStartTimes.Init(Floor(EncodeDate(2021, 03, 06))); // Saturday

  Test_TryGetSlot(90);
  Test_TryGetSlot(90);
  Test_TryGetSlot(90);
  actual1 := Test_TryGetSlot(90);
  actual2 := Test_TryGetSlot(90);

  Assert.AreEqual('RoomB 2021-03-07 00:30', actual1);
  Assert.AreEqual('', actual2);
end;

function TestGenRoomStartTimes.Test_TryGetSlot(const aLength: integer): string;
var
  isAvailable: Boolean;
  startDate: TDateTime;
  room: TRoom;
begin
  isAvailable := fRoomStartTimes.TryGetSlot(aLength, startDate, room);
  if not isAvailable then
    Exit('');
  Result := room.Name + ' ' + FormatDateTime('yyyy-mm-dd hh:nn', startDate);
end;

initialization

TDUnitX.RegisterTestFixture(TestGenRoomStartTimes);

end.
