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
	Entities = [],

	OnPaint = fun(_Evt, _Obj) ->
		Canvas = wxGraphicsContext:create(Panel),
		%% Don't care about drawing the outlines (yet?) so no Pen for now
		%%Pen = wxPen:new(),
		%%wxPen:setWidth(Pen, 3),
		%%wxPen:setColour(Pen, ?wxBLACK),
		Brush = wxBrush:new(),
		wxBrush:setColour(Brush, ?wxBLACK),
		%%wxGraphicsContext:setPen(Canvas, Pen),
		wxGraphicsContext:setBrush(Canvas, Brush),
		wxGraphicsContext:drawLines(Canvas, [{190, 90}, {190,60}, {50, 60}], [{fillStyle, ?wxODDEVEN_RULE}]),
		wxGraphicsContext:destroy(Canvas)
	end,

	%% Connect some callbacks/messages
	wxFrame:connect(Panel, paint, [{callback, OnPaint}]),
	wxFrame:connect(Frame, close_window), % works   ??

	wxFrame:center(Frame),
	wxFrame:show(Frame),
	loop({Frame, Panel, Entities}).


%% Main loop updating entities and rendering
loop(State) ->
	{Frame, Panel, Entities} = State,
	io:format("--waiting in main loop--~n", []),
	receive
		#wx{event=#wxClose{}} ->
			io:format("Closing window ~n", []),
			wxWindow:destroy(Frame),
			ok;
	%A = #wx{id = ID, event=#wxCommand{type = command_button}}
	Msg ->
		%everthing else ends up here
		io:format("loop default triggered: Got ~n ~p ~n", [Msg]),
		loop(State)
end.
