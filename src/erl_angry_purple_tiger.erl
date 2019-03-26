-module(erl_angry_purple_tiger).

%% API exports
-export([animal_name/1, hex_digest/1]).

-include("src/erl_angry_purple_tiger.hrl").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

%%====================================================================
%% API functions
%%====================================================================
animal_name(String) ->
    [AdjectiveIndex, ColorIndex, AnimalIndex] = hex_digest(String),
    {lists:nth(AdjectiveIndex+1, ?ADJECTIVES), lists:nth(ColorIndex+1, ?COLORS), lists:nth(AnimalIndex+1, ?ANIMALS)}.

%%====================================================================
%% Internal functions
%%====================================================================
hex_digest(Input) ->
    Digest = erlang:md5(Input),
    compress(byte_size(Digest) div 3, Digest, []).

compress(Size, Bin, Acc) ->
    case Bin of
        <<Segment:Size/binary, Tail/binary>> when byte_size(Tail) >= Size ->
            Res = lists:foldl(fun(B, A) -> B bxor A end, 0, binary_to_list(Segment)),
            compress(Size, Tail, [Res|Acc]);
        Segment ->
            Res = lists:foldl(fun(B, A) -> B bxor A end, 0, binary_to_list(Segment)),
            lists:reverse([Res|Acc])
    end.
%% ------------------------------------------------------------------
%% EUNIT Tests
%% ------------------------------------------------------------------
-ifdef(TEST).

basic_test() ->
    Known = "112CuoXo7WCcp6GGwDNBo6H5nKXGH45UNJ39iEefdv2mwmnwdFt8",
    ?assertEqual("feisty glass dalmatian", animal_name(Foo)).

-endif.
