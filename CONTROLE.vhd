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
		input 			: in std_logic_vector(DATA_WIDTH-1 downto 0);
		reset 			: in std_logic;
		greater_then	: in std_logic;
		less_then		: in std_logic;
		equal			: in std_logic;
		increment_pc	: out std_logic;
		data_stack_from	: out std_logic_vector(1 downto 0);
		load_stack		: out std_logic_vector(1 downto 0);
		write_stack		: out std_logic;
		op_ula			: out std_logic_vector(1 downto 0);
		op_pc			: out std_logic;
		jump			: out std_logic;
		op_branch		: out std_logic;
		load_branch		: out std_logic;
		write_var		: out std_logic;
		var_address		: out std_logic;
		reset_out		: out std_logic;
		branch_out		: out std_logic_vector(DATA_WIDTH-1 downto 0);
		inst			: out std_logic_vector(DATA_WIDTH-1 downto 0);
		jump_out		: out std_logic
	);

end entity;

architecture rtl of CONTROLE is

	-- Build an enumerated type for the state machine
	type state_type is (
		resetPC,
		atualizaPC,
		atualizaPC2,
		incremento_adicional,
		incremento_adicional2,
		leInstrucao,
		decodifica,
		leBranch1,
		leBranch2,
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

	signal res_salto		: std_logic;
	signal write_opcode 	: std_logic;
	signal opcode : std_logic_vector(DATA_WIDTH-1 downto 0);
	--signal std_logic_vector
begin

op_ula <= input(1 downto 0);
branch_out <= "0000" & input(3 downto 0);
inst <= opcode;
jump_out <= res_salto;

	-- Logic to advance to the next state
	process (clk, reset, res_salto)
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
				when atualizaPC2 =>
					state <= leInstrucao;
				when leInstrucao =>
					state <= decodifica;
				when decodifica=>
					res_salto <= '0';
					-- iconst, bipush
					if (opcode(DATA_WIDTH-1 downto 4) = "0000" or opcode(DATA_WIDTH-1 downto 3) = "00010") then
						state <= escrevePilha;
					-- iload, iload_
					elsif (opcode(DATA_WIDTH-1 downto 3) = "00011" or opcode(DATA_WIDTH-1 downto 4) = "0010") then
						state <= leMemoria;
					-- istore, istore_
					elsif (opcode(DATA_WIDTH-1 downto 4) = "0011" or opcode(DATA_WIDTH-1 downto 4) = "0101") then
						state <= lePilha;
					-- iadd, isub, imul, ificmp
					elsif (opcode(DATA_WIDTH-1 downto 4) = "0110" or opcode(DATA_WIDTH-1 downto 4) = "1010") then
						state <= lePilha;
					-- goto, goto_w
					elsif (opcode(DATA_WIDTH-1 downto 3) = "10111" or opcode(DATA_WIDTH-1 downto 6) = "11") then
						state <= incremento_adicional;
						res_salto <= '0';
					else --if (opcode(DATA_WIDTH-1 downto 4) = "1000") then
						state <= NOP;
					end if;
				when escrevePilha =>
					-- bipush, iload
					if (opcode(DATA_WIDTH-1 downto 3) = "00010" or opcode(DATA_WIDTH-1 downto 3) = "00011") then
						state <= atualizaPC2;
					else
						state <= atualizaPC;
					end if;
				when incremento_adicional =>
					state <= leBranch1;
				when incremento_adicional2 =>
					state <= leBranch2;
				when lePilha =>
					-- iadd, isub, imul
					if (opcode(DATA_WIDTH-1 downto 4) = "0110") then
						state <= escrevePilha;
					-- ificmp
					elsif (opcode(DATA_WIDTH-1 downto 4) = "1010") then
						state <= incremento_adicional;
						-- EQ
						if (opcode(3 downto 0) = "1111") then
							res_salto <= equal;
						-- NE
						elsif (opcode(3 downto 0) = "0000") then
							res_salto <= not equal;
						-- LT
						elsif (opcode(3 downto 0) = "0001") then
							res_salto <= less_then;
						-- GE
						elsif (opcode(3 downto 0) = "0010") then
							res_salto <= equal or greater_then;
						-- GT
						elsif (opcode(3 downto 0) = "0011") then
							res_salto <= greater_then;
						-- LE
						else-- (opcode(3 downto 0) = "0100") then
							res_salto <= equal or less_then;
						end if;
					-- istore, istore_
					else
						state <= escreveMemoria;
					end if;
				when leBranch1 =>
					if (opcode(DATA_WIDTH-1 downto 4) = "1010" or opcode(DATA_WIDTH-1 downto 3) = "10111") then
						state <= atualizaPC2;
					else
						state <= incremento_adicional2;
					end if;
				when leBranch2 =>
					state <= atualizaPC2;
				when leMemoria =>
					state <= escrevePilha;
				when escreveMemoria =>
					-- istore
					if (opcode(DATA_WIDTH-1 downto 4) = "0011") then
						state <= atualizaPC2;
					else
						state <= atualizaPC;
					end if;
				when NOP =>
					state <= NOP;
			end case;
		end if;
	end process;

	-- Logic to determine output
	process (state,opcode,res_salto)
	begin
		increment_pc <= '0';
		data_stack_from <= (others=>'0');
		load_stack <= (others=>'0');
		write_stack	<= '0';
		write_var <= '0';
		write_opcode <= '0';
		reset_out <= '0';
		var_address	<= '0';
		op_pc <= '0';
		jump <= '0';
		op_branch <= '0';
		load_branch <= '0';
		case state is
			when resetPC =>
				reset_out <= '1';
			when atualizaPC =>
				increment_pc <= '1';
				op_pc <= '0';
				-- if_icmp, goto, goto_w
				if ((opcode(DATA_WIDTH-1 downto 4) = "1010" or opcode(DATA_WIDTH-1 downto 3) = "10111" or opcode(DATA_WIDTH-1 downto 6) = "11") and res_salto = '0' ) then
					jump <= '1';
				end if;
			when atualizaPC2 =>
				increment_pc <= '1';
				op_pc <= '1';
				-- if_icmp, goto, goto_w
				if ((opcode(DATA_WIDTH-1 downto 4) = "1010" or opcode(DATA_WIDTH-1 downto 3) = "10111" or opcode(DATA_WIDTH-1 downto 6) = "11") and res_salto = '0' ) then
					jump <= '1';
				end if;
			when incremento_adicional =>
				increment_pc <= '1';
				op_pc <= '0';
			when incremento_adicional2 =>
				increment_pc <= '1';
				op_pc <= '1';
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
				-- iload, iload_
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
				op_branch <= '0';
			when leBranch2 =>
				load_branch <= '1';
				op_branch <= '1';
			when NOP =>
				reset_out <= '1';
		end case;
	end process;
end rtl;
