-module(asterloids).

%% what does this do?
%%-behaviour(wx_object).

-export([start/0]).

-include_lib("wx/include/wx.hrl").

-define(wxMAC_USE_CORE_GRAPHICS, 1).

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
	Win = wxPanel:new(Frame, [{style, ?wxFULL_REPAINT_ON_RESIZE}]),
	Entities = [],

	OnPaint = fun(_Evt, _Obj) ->
		Canvas = wxGraphicsContext:create(Win),
		%% Don't care about drawing the outlines (yet?) so no Pen for now
		%%Pen = wxPen:new(),
		%%wxPen:setWidth(Pen, 3),
		%%wxPen:setColour(Pen, ?wxWHITE),
		Brush = wxBrush:new(),
		wxBrush:setColour(Brush, ?wxWHITE),
		%%wxGraphicsContext:setPen(Canvas, Pen),
		wxGraphicsContext:setBrush(Canvas, Brush),
		wxGraphicsContext:drawLines(Canvas, [{190, 90}, {190,60}, {50, 60}], [{fillStyle, ?wxODDEVEN_RULE}]),
		wxGraphicsContext:destroy(Canvas)
	end,

	%% Connect some callbacks/messages
	wxWindow:connect(Win, paint, [{callback, OnPaint}]),
	wxWindow:connect(Win, close_window), % works   ??
	wxWindow:connect(Win, key_down),
	wxWindow:connect(Win, key_up),
	
	wxPanel:setBackgroundColour(Win, ?wxBLACK),
	wxFrame:center(Frame),
	wxFrame:show(Frame),
	loop({Win, Entities}).


%% Main loop updating entities and rendering
loop(State) ->
	{Win, Entities} = State,
	io:format("--waiting in main loop--~n", []),
	receive
		#wx{event=#wxClose{}} ->
			io:format("Closing window ~n", []),
			wxWindow:destroy(Win),
			ok;
		#wx{event=#wxKey{rawCode = KeyCode}} ->
    		case KeyCode of
        		$c ->
	    			%%wxFrame:destroy(S#state.frame),
	    			%%opt_unlink(S#state.parent_pid),
            		%%{stop, normal, S};
            	io:format("Closing window ~n", []),
				wxWindow:destroy(Win);
        		%%$f ->

        	%% default
        	_ ->
            	io:format("~p: ignored: ~p~n", [?MODULE, KeyCode])
        	end,
        	loop(State);

		%A = #wx{id = ID, event=#wxCommand{type = command_button}}

		Msg ->
			%everthing else ends up here
			io:format("loop default triggered: Got ~n ~p ~n", [Msg]),
			loop(State)
	end.
