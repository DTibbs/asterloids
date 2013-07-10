-module(asterloids).

%% what does this do?
%%-behaviour(wx_object).

-export([start/0]).

-include_lib("wx/include/wx.hrl").

%% This is to save things to the state
%%-record(state,
%%		{
%%			config,
%%			win,
%%			pen,
%%			brush,
%%			font
%%		}).

%% what does this do?
%%start(Config) -> 
%%	wx_object:start_link(?MODULE, Config, []).

%% our 'main' startup function
start() ->
	Wx = wx:new(),
	Frame = wxFrame:new(Wx, -1, "FIRST", [{size, {800,600}}]),
	Panel = wxPanel:new(Frame),

	OnPaint = fun(_Evt, _Obj) ->
		Canvas = wxGraphicsContext:create(Panel),
		Pen = wxPen:new(),
		wxPen:setWidth(Pen, 3),
		wxPen:setColour(Pen, ?wxBLACK),
		wxGraphicsContext:setPen(Canvas, Pen),
		wxGraphicsContext:drawLines(Canvas, [{50, 60}, {190,60}]),
		wxGraphicsContext:destroy(Canvas)
	end,

	wxFrame:connect(Panel, paint, [{callback, OnPaint}]),
	wxFrame:connect(Panel, close_window), % works   ??
	wxFrame:center(Frame),
	wxFrame:show(Frame).

