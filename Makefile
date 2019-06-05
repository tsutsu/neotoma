.PHONY: test compile clean dialyzer bootstrap escript

all: compile

compile: src/neotoma_parse.erl
	@./rebar compile

src/neotoma_parse.erl:
	@cp src/neotoma_parse.erl.safe src/neotoma_parse.erl

test:
	@./rebar eunit

clean:
	@./rebar clean
	@rm -f src/neotoma_parse.erl

neotoma.plt:
	@dialyzer --build_plt --apps erts kernel stdlib compiler crypto hipe \
		syntax_tools --output_plt neotoma.plt

dialyzer: compile neotoma.plt
	@dialyzer --plt neotoma.plt ebin

xref: compile
	@./rebar xref skip_deps=true

bootstrap: compile
	@erl -pz ebin -b start_sasl -noshell -s init stop -s neotoma bootstrap
	@./rebar compile

escript:
	@./rebar escriptize
