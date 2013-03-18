-module(cbtutorial_greeting_controller, [Req]).
-compile(export_all).

index('GET', []) ->
    Greetings = boss_db:find(greeting, []),
    {ok, [{greetings, Greetings}]}.

create('GET', []) ->
    NewGreeting = greeting:new(id, ""),
    {ok, [{new_greeting, NewGreeting}]};
create('POST', []) ->
    GreetingText = Req:post_param("greeting_text"),
    NewGreeting = greeting:new(id, GreetingText),
    case NewGreeting:save() of
        {ok, SavedGreeting} ->
            {redirect, [{action, "index"}]};
        {error, ErrorList} ->
            {ok, [{errors, ErrorList}, {new_greeting, NewGreeting}]}
    end.

pull('POST', [LastTimestamp]) ->
    {ok, Timestamp, Greetings} = boss_mq:pull("new-greetings",
        list_to_integer(LastTimestamp)),
    {json, [{timestamp, Timestamp}, {greetings, Greetings}]}.

live('GET', []) ->
    Greetings = boss_db:find(greeting, []),
    Timestamp = boss_mq:now("new-greetings"),
    {ok, [{greetings, Greetings}, {timestamp, Timestamp}]}.
