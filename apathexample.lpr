// https://stackoverflow.com/questions/9079969/a-dijkstras-algorithm-simple-implementation-pascal
uses
    crt;

const
    MAXX = 20;
    MAXY = 25;

type
    TArr = array [0..MAXY, 0..MAXX] of integer;

    TCell = record
        x: integer;
        y: integer;
    end;

    TListCell = record
        x: integer;
        y: integer;
        G: integer;
        parent: TCell;
    end;

    TListArr = array [1..10000] of TListCell;

    TList = record
        arr: TListArr;
        len: integer;
    end;

var
    i, j, minind, ind, c: integer;
    start, finish: TCell;
    current: TListCell;
    field: TArr;
    opened, closed: TList;

procedure ShowField;
var
    i, j: integer;
begin
    textcolor(15);
    for i := 0 to MAXX do
    begin
        for j := 0 to MAXY do
        begin
            case field[j, i] of
                99: textcolor(8);  // not walkable
                71: textcolor(14); // walkable
                11: textcolor(10); // start
                21: textcolor(12); // finish
                15: textcolor(2);  // path
                14: textcolor(5);
                16: textcolor(6);
            end;
            write(field[j, i], ' ');
        end;
        writeln;
    end;
    textcolor(15);
end;


procedure AddClosed(a: TListCell);
begin
    closed.arr[closed.len + 1] := a;
    inc(closed.len);
end;


procedure AddOpened(x, y, G: integer);
begin
    opened.arr[opened.len + 1].x := x;
    opened.arr[opened.len + 1].y := y;
    opened.arr[opened.len + 1].G := G;
    inc(opened.len);
end;

procedure DelOpened(n: integer);
var
    i: integer;
begin
    AddClosed(opened.arr[n]);
    for i := n to opened.len - 1 do
        opened.arr[i] := opened.arr[i + 1];
    dec(opened.len);
end;


procedure SetParent(var a: TListCell; parx, pary: integer);
begin
    a.parent.x := parx;
    a.parent.y := pary;
end;


function GetMin(var a: TList): integer;
var
    i, min, mini: integer;
begin
    min := MaxInt;
    mini := 0;
    for i := 1 to a.len do
        if a.arr[i].G < min then
        begin
            min := a.arr[i].G;
            mini := i;
        end;

    GetMin := mini;
end;


function FindCell(a: TList; x, y: integer): integer;
var
    i: integer;
begin
    FindCell := 0;
    for i := 1 to a.len do
        if (a.arr[i].x = x) and (a.arr[i].y = y) then
        begin
            FindCell := i;
            break;
        end;
end;


procedure ProcessNeighbourCell(x, y: integer);
begin
    if (field[current.x + x, current.y + y] <> 99) then    // if walkable
        if (FindCell(closed, current.x + x, current.y + y) <= 0) then // and not visited before
            if (FindCell(opened, current.x + x, current.y + y) <= 0) then // and not added to list already
            begin
                AddOpened(current.x + x, current.y + y, current.G + 10);
                SetParent(opened.arr[opened.len], current.x, current.y);
                //  field[opened.arr[opened.len].x, opened.arr[opened.len].y]:=16;
            end
                else
            begin

            end;
end;


begin
    randomize;
    for i := 0 to MAXX do
        for j := 0 to MAXY do
            field[j, i] := 99;

    for i := 1 to MAXX - 1 do
        for j := 1 to MAXY - 1 do
            if random(5) mod 5 = 0 then
                field[j, i] := 99
            else field[j, i] := 71;

    // start and finish positions coordinates
    start.x := 5;
    start.y := 3;
    finish.x := 19;
    finish.y := 16;
    field[start.x, start.y] := 11;
    field[finish.x, finish.y] := 21;

    ShowField;

    writeln;

    opened.len := 0;
    closed.len := 0;
    AddOpened(start.x, start.y, 0);
    SetParent(opened.arr[opened.len], -1, -1);
    current.x := start.x;
    current.y := start.y;

    repeat
        minind := GetMin(opened);
        current.x := opened.arr[minind].x;
        current.y := opened.arr[minind].y;
        current.G := opened.arr[minind].G;
        DelOpened(minind);

        ProcessNeighbourCell(1, 0);  // look at the cell to the right
        ProcessNeighbourCell(-1, 0); // look at the cell to the left
        ProcessNeighbourCell(0, 1);  // look at the cell above
        ProcessNeighbourCell(0, -1); // look at the cell below

        if (FindCell(opened, finish.x, finish.y) > 0) then
            break;
    until opened.len = 0;

    // count and mark path
    c := 0;
    while ((current.x <> start.x) or (current.y <> start.y)) do
    begin
        field[current.x, current.y] := 15;
        ind := FindCell(closed, current.x, current.y);
        current.x := closed.arr[ind].parent.x;
        current.y := closed.arr[ind].parent.y;
        inc(c);
    end;


    ShowField;
    writeln(c);
    readln;
end.
