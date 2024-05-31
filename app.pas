library app;

procedure rect(x, y, w, h: double); external 'canvas' name 'rect';
procedure fill(color: integer); external 'canvas' name 'fill';
procedure stroke(color: integer); external 'canvas' name 'stroke';
procedure beginPath(); external 'canvas' name 'beginPath';
procedure clearCanvas(); external 'canvas' name 'clearCanvas';


type TCandle = record
  min, max, open, close: double;
end;

const SIZE = 3;
const WIDTH = 20;
var candles: array[0..SIZE] of TCandle;

function addCandle(min: double; max: double; open: double; close: double; i: integer): integer;
var candle: TCandle;
begin
  candle.min := min;
  candle.max := max;
  candle.open := open;
  candle.close := close;
  candles[i] := candle;

  addCandle := SIZE;
end;

procedure draw();
var candle: TCandle;
var height: double;
var i: integer;
var x: double;
begin
  clearCanvas();

  for i := 0 to SIZE -1 do
  begin
    candle := candles[i];

    x := i*WIDTH*2 + 10;
    beginPath();
    rect(x+WIDTH/2, candle.max, 1, candle.min - candle.max);
    stroke($00F);
    
    beginPath();
    height := candle.close - candle.open;
    rect(x, candle.open, WIDTH, height);
    fill($F0F);
    
    beginPath();
    rect(x, candle.open, WIDTH, height);
    stroke($00F);
  end;
end;

exports
  draw name 'draw',
  addCandle name 'addCandle';
end.