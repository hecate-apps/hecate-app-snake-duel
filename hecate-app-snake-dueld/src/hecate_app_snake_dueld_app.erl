%%% @doc Snake Duel daemon application.
%%%
%%% In in-VM mode: no-op (app_snake_duel callback handles initialization).
%%% The application is kept for OTP compliance but the real entry point
%%% for in-VM plugins is app_snake_duel:init/1.
%%% @end
-module(hecate_app_snake_dueld_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    logger:info("[hecate_app_snake_dueld] Application started (in-VM mode)"),
    hecate_app_snake_dueld_sup:start_link().

stop(_State) ->
    ok.
