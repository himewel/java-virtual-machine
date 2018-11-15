-- Quartus II VHDL Template
-- Safe State Machine

library ieee;
use ieee.std_logic_1164.all;

entity CONTROLE is
	generic (
		DATA_WIDTH: natural:= 8
	);

	port(
		clk				: in std_logic;
		input	 			: in std_logic_vector(DATA_WIDTH-1 downto 0);
		reset	 			: in std_logic;
		greater_then	: in std_logic;
		less_then		: in std_logic;
		equal				: in std_logic;
		increment_pc	: out std_logic;
		data_stack_from: out std_logic_vector(1 downto 0);
		load_stack		: out std_logic_vector(1 downto 0);
		write_stack		: out std_logic;
		op_ula			: out std_logic_vector(1 downto 0);
		jump				: out std_logic;
		op_branch		: out std_logic;
		load_branch		: out std_logic;
		write_var		: out std_logic;
		var_address		: out std_logic;
		reset_out		: out std_logic;
		branch_out		: out std_logic_vector(DATA_WIDTH-1 downto 0)--;
	);

end entity;

architecture rtl of CONTROLE is

	-- Build an enumerated type for the state machine
	type state_type is
	(
		resetPC,
		atualizaPC,
		incremento_adicional,
		leInstrucao,
		decodifica,
		leBranch1,
		leBranch2,
		--verificaComparacao,
		leBranch3,
		leBranch4,
		escrevePilha,
		lePilha,
		escreveMemoria,
		leMemoria,
		NOP
	);

	-- Register to hold the current state
	signal state   : state_type;

	-- Attribute "safe" implements a safe state machine.
	-- This is a state machine that can recover from an
	-- illegal state (by returning to the reset state).
	attribute syn_encoding : string;
	attribute syn_encoding of state_type : type is "safe";

	signal cont_operandos: natural range 0 to 3;
	signal cont_salto		: std_logic;
	signal write_opcode 	: std_logic;
	signal opcode : std_logic_vector(DATA_WIDTH-1 downto 0);
	--signal std_logic_vector
begin

op_ula <= input(1 downto 0);
branch_out <= "0000" & input(3 downto 0);

	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if (reset = '1') then
				state <= resetPC;
				opcode <= (others=>'0');
		elsif (rising_edge(clk)) then
			if (write_opcode = '1') then
				opcode <= input;
			end if;
			case state is
				when resetPC =>
					state <= leInstrucao;
				when atualizaPC =>
					state <= leInstrucao;
				when leInstrucao =>
					state <= decodifica;
				when decodifica=>
					-- iconst
					if (opcode(DATA_WIDTH-1 downto 4) = "0000") then
						state <= escrevePilha;
					-- bipush
					elsif (opcode(DATA_WIDTH-1 downto 3) = "00010") then
						state <= incremento_adicional;
					-- iload
					elsif (opcode(DATA_WIDTH-1 downto 3) = "00011") then
						state <= incremento_adicional;
					-- iload_
					elsif (opcode(DATA_WIDTH-1 downto 4) = "0010") then
						state <= leMemoria;
					-- istore
					elsif (opcode(DATA_WIDTH-1 downto 4) = "0011") then
						state <= incremento_adicional;
					-- istore_
					elsif (opcode(DATA_WIDTH-1 downto 4) = "0101") then
						state <= lePilha;
					-- iadd, isub, imul
					elsif (opcode(DATA_WIDTH-1 downto 4) = "0110") then
						state <= lePilha;
					-- ificmp
					elsif (opcode(DATA_WIDTH-1 downto 4) = "1010") then
						state <= lePilha;
					-- goto
					elsif (opcode(DATA_WIDTH-1 downto 3) = "10111") then
						state <= incremento_adicional;
						cont_salto <= '1';
					-- goto_w
					elsif (opcode(DATA_WIDTH-1 downto 6) = "11") then
						state <= incremento_adicional;
					else--if (opcode(DATA_WIDTH-1 downto 4) = "1000") then
						state <= NOP;
					end if;
				when escrevePilha =>
					state <= atualizaPC;
				when incremento_adicional =>
					-- bipush
					if (opcode(DATA_WIDTH-1 downto 3) = "00010") then
						state <= escrevePilha;
					-- iload
					elsif (opcode(DATA_WIDTH-1 downto 3) = "00011") then
						state <= leMemoria;
					-- istore
					elsif (opcode(DATA_WIDTH-1 downto 4) = "0011") then
						state <= lePilha;
					-- goto_w
					elsif (opcode(DATA_WIDTH-1 downto 6) = "11") then
						if (cont_operandos = 0) then
							state <= leBranch1;
							cont_operandos <= 1;
						elsif (cont_operandos = 1) then
							state <= leBranch2;
							cont_operandos <= 2;
						elsif (cont_operandos = 2) then
							state <= leBranch3;
							cont_operandos <= 2;
						else
							state <= leBranch4;
							cont_operandos <= 0;
						end if;
					-- if_icmp ou goto
					else -- (opcode(DATA_WIDTH-1 downto 4) = "1010") then
						if (cont_salto = '1') then
							if (cont_operandos = 0) then
								state <= incremento_adicional;
								cont_operandos <= cont_operandos + 1;
							else
								state <= atualizaPC;
								cont_operandos <= 0;
							end if;
						else
							if (cont_operandos = 0) then
								state <= leBranch1;
								cont_operandos <= 1;
							else -- (cont_operandos = 1) then
								state <= leBranch2;
								cont_operandos <= 0;
							end if;
						end if;
					end if;
				when lePilha =>
					-- iadd, isub, imul
					if (opcode(DATA_WIDTH-1 downto 4) = "0110") then
						state <= escrevePilha;
					-- ificmp
					elsif (opcode(DATA_WIDTH-1 downto 4) = "1010") then
						state <= incremento_adicional;
						-- EQ
						if (opcode(3 downto 0) = "1111") then
							cont_salto <= equal;
						-- NE
						elsif (opcode(3 downto 0) = "0000") then
							cont_salto <= not equal;
						-- LT
						elsif (opcode(3 downto 0) = "0001") then
							cont_salto <= less_then;
						-- GE
						elsif (opcode(3 downto 0) = "0010") then
							cont_salto <= equal or greater_then;
						-- GT
						elsif (opcode(3 downto 0) = "0011") then
							cont_salto <= greater_then;
						-- LE
						else-- (opcode(3 downto 0) = "0100") then
							cont_salto <= equal or less_then;
						end if;
					-- istore, istore_
					else
						state <= escreveMemoria;
					end if;
				when leBranch1 =>
					state <= incremento_adicional;
				when leBranch2 =>
					-- if_icmp, goto
					if (opcode(DATA_WIDTH-1 downto 4) = "1010" or opcode(DATA_WIDTH-1 downto 3) = "10111") then
						state <= atualizaPC;
					-- goto_w
					else
						state <= incremento_adicional;
					end if;
				when leBranch3 =>
					state <= incremento_adicional;
				when leBranch4 =>
					state <= atualizaPC;
				when leMemoria =>
					state <= escrevePilha;
				when escreveMemoria =>
					state <= atualizaPC;
				when NOP =>
					state <= NOP;
			end case;
		end if;
	end process;

	-- Logic to determine output
	process (state,opcode)
	begin
		increment_pc <= '0';
		data_stack_from <= (others=>'0');
		load_stack <= (others=>'0');
		write_stack	<= '0';
		write_var <= '0';
		write_opcode <= '0';
		reset_out <= '0';
		var_address	<= '0';
		jump <= '0';
		op_branch <= '0';
		load_branch <= '0';
		case state is
			when resetPC =>
				reset_out <= '1';
			when atualizaPC =>
				increment_pc <= '1';
				-- if_icmp
				if (opcode(DATA_WIDTH-1 downto 4) = "1010") then
					jump <= '1';
				end if;
			when incremento_adicional =>
				increment_pc <= '1';
			when leInstrucao =>
				write_opcode <= '1';
			when decodifica=>
				increment_pc <= '0';
			when escrevePilha =>
				write_stack	<= '1';
				-- iconst
				if (opcode(DATA_WIDTH-1 downto 4) = "0000") then
					data_stack_from <= "01";
				-- iadd, imul, isub
				elsif (opcode(DATA_WIDTH-1 downto 4) = "0110") then
					data_stack_from <= "10";
				-- bipush
				elsif (opcode(DATA_WIDTH-1 downto 3) = "00010") then
					data_stack_from <= "00";
				-- iload, iload__
				else
					data_stack_from <= "11";
				end if;
			when lePilha =>
				-- iadd, imul, isub, if_icmp
				if (opcode(DATA_WIDTH-1 downto 4) = "0110" or opcode(DATA_WIDTH-1 downto 4) = "1010") then
					load_stack <= "11";
				-- istore, istore_
				else
					load_stack <= "10";
				end if;
			when escreveMemoria =>
				write_var <= '1';
				-- istore
				if (opcode(DATA_WIDTH-1 downto 4) = "0011") then
					var_address	<= '0';
				-- istore_
				else
					var_address	<= '1';
				end if;
			when leMemoria =>
				-- iload
				if (opcode(DATA_WIDTH-1 downto 3) = "00011") then
					var_address	<= '0';
				-- iload_
				else
					var_address	<= '1';
				end if;
			when leBranch1 =>
				load_branch <= '0';
			when leBranch2 =>
				load_branch <= '0';
			when leBranch3 =>
				load_branch <= '1';
				op_branch <= '1';
			when leBranch4 =>
				load_branch <= '1';
				op_branch <= '1';
			when NOP =>
				reset_out <= '1';
		end case;
	end process;
end rtl;
