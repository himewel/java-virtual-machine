library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Main is
	generic
	(
		DATA_WIDTH_EXT : natural;
		ADDR_WIDTH_EXT : natural;
		ADDR_VAR_WIDTH_EXT	: natural
	);

	port (
		clk_externo	: in std_logic;
		rst_externo : in std_logic;
		pc_counter	: out std_logic_vector(ADDR_WIDTH_EXT-1 downto 0);
		data_out	: out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
		stack_in 	: out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
		stack_out	: out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
		ula_out 	: out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
		a			: out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
		b			: out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
		out_addr	: out std_logic_vector(ADDR_WIDTH_EXT-1 downto 0);
		igual		: out std_logic;
		maior		: out std_logic;
		menor		: out std_logic;
		jump_out	: out std_logic
	);
end entity;

architecture rtl of Main is
signal pc_address: std_logic_vector(ADDR_WIDTH_EXT-1 downto 0);
signal out_ram: std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
signal out_ram1: std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
signal out_stack1: std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
signal out_stack2: std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
signal out_ula: std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
signal out_var: std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
signal branch_controle: std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
signal opBranch_ext: std_logic;
signal data_stack: std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
signal var_address: std_logic_vector(ADDR_VAR_WIDTH_EXT-1 downto 0);
signal jmp_address_signal: std_logic_vector(ADDR_WIDTH_EXT-1 downto 0);
signal eq_signal,gt_signal,lt_signal: std_logic;
signal increment_pc_signal: std_logic;
signal data_stack_from_signal: std_logic_vector(1 downto 0);
signal load_stack_signal: std_logic_vector(1 downto 0);
signal write_stack_signal: std_logic;
signal op_ula_signal: std_logic_vector(1 downto 0);
signal write_var_signal: std_logic;
signal var_address_signal: std_logic;
signal reset_signal: std_logic;
signal load_branch_signal: std_logic;
signal op_branch_signal: std_logic;
signal jump_signal: std_logic;
signal op_pc_signal: std_logic;
signal to_convert: natural range 0 to 2**(ADDR_VAR_WIDTH_EXT-1);
signal to_convert1: natural range 0 to 2**(ADDR_WIDTH_EXT-1);

	component CONTROLE is
		generic (
			DATA_WIDTH: natural
		);
		port (
			clk				: in std_logic;
			input	 		: in std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
			reset	 		: in std_logic;
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
			branch_out		: out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
			jump_out			: out std_logic
		);
	end component;

	component RAM is
		generic (
			DATA_WIDTH : natural;
			ADDR_WIDTH : natural
		);
		port (
			clk		: in std_logic;
			addr	: in integer range 0 to 2**ADDR_WIDTH_EXT-1;
			q1		: out std_logic_vector((DATA_WIDTH_EXT -1) downto 0);
			q2		: out std_logic_vector((DATA_WIDTH_EXT -1) downto 0)
		);
	end component;

	component PC is
		generic (
			DATA_WIDTH : natural;
			ADDR_WIDTH : natural
		);
		port (
			enable 	: in std_logic;
			rst		: in std_logic;
			op		: in std_logic;
			jmp		: in std_logic;
			inPC	: in std_logic_vector(ADDR_WIDTH_EXT-1 downto 0);
			outPC	: out std_logic_vector(ADDR_WIDTH_EXT-1 downto 0)
		);
	end component;

	component ULA is
		generic (
			DATA_WIDTH: natural
		);
		port (
			clk: in std_logic;
			op		: in std_logic_vector(1 downto 0);
			op1	: in std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
			op2	: in std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
			outOP		: out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
			greater_then: out std_logic;
			less_then: out std_logic;
			equal	: out std_logic;
			Aa: out std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
			Bb: out std_logic_vector(DATA_WIDTH_EXT-1 downto 0)
		);
	end component;

	component STACK is
		generic (
			DATA_WIDTH : natural;
			ADDR_WIDTH : natural
		);
		port
		(
			clk		: in std_logic;
			data		: in std_logic_vector((DATA_WIDTH_EXT-1) downto 0);
			we			: in std_logic;
			le			: in std_logic_vector(1 downto 0);
			out1		: out std_logic_vector((DATA_WIDTH_EXT-1) downto 0);
			out2		: out std_logic_vector((DATA_WIDTH_EXT-1) downto 0)
		);
	end component;

	component VAR is
		generic (
			DATA_WIDTH : natural;
			ADDR_WIDTH : natural
		);
		port
		(
			clk		: in std_logic;
			addr	: in integer range 0 to 2**ADDR_VAR_WIDTH_EXT-1;
			data	: in std_logic_vector((DATA_WIDTH_EXT-1) downto 0);
			we		: in std_logic;
			q		: out std_logic_vector((DATA_WIDTH_EXT -1) downto 0)
		);
	end component;

	component BRANCH is
		generic (
			DATA_WIDTH : natural;
			ADDR_WIDTH : natural
		);
		port (
			clk: in std_logic;
			branch_in1: in std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
			branch_in2: in std_logic_vector(DATA_WIDTH_EXT-1 downto 0);
			selec_in : in std_logic;
			opBranch : in std_logic;
			outAddr: out std_logic_vector(ADDR_WIDTH_EXT-1 downto 0)
		);
	end component;
begin
	pc_counter <= pc_address;
	data_out <= out_ram;
	stack_in <= data_stack;
	stack_out <= out_stack2;
	ula_out <= out_ula;
	igual <= eq_signal;
	maior <= gt_signal;
	menor <= lt_signal;
	out_addr <= jmp_address_signal;

	control: CONTROLE
		generic map (
			DATA_WIDTH => DATA_WIDTH_EXT
		)
		port map (
			clk => clk_externo,
			input => out_ram,
			reset => rst_externo,
			greater_then => gt_signal,
			less_then => lt_signal,
			equal => eq_signal,
			increment_pc => increment_pc_signal,
			data_stack_from => data_stack_from_signal,
			load_stack => load_stack_signal,
			write_stack	=> write_stack_signal,
			op_ula => op_ula_signal,
			jump => jump_signal,
			op_branch => op_branch_signal,
			op_pc => op_pc_signal,
			load_branch => load_branch_signal,
			write_var => write_var_signal,
			var_address	=> var_address_signal,
			reset_out => reset_signal,
			branch_out => branch_controle,
			jump_out => jump_out
	);

	to_convert <= to_integer(signed(pc_address));

	mem: RAM
		generic map (
			DATA_WIDTH => DATA_WIDTH_EXT,
			ADDR_WIDTH => ADDR_WIDTH_EXT
		)
		port map (
			clk => clk_externo,
			addr => to_convert,
			q1 => out_ram,
			q2 => out_ram1
	);

	program_counter: PC
		generic map (
			DATA_WIDTH => DATA_WIDTH_EXT,
			ADDR_WIDTH => ADDR_WIDTH_EXT
		)
		port map (
			enable => increment_pc_signal,
			rst => reset_signal,
			jmp => jump_signal,
			op => op_pc_signal,
			inPC => jmp_address_signal,
			outPC => pc_address
	);

	pilha: STACK
		generic map (
			DATA_WIDTH => DATA_WIDTH_EXT,
			ADDR_WIDTH => ADDR_VAR_WIDTH_EXT
		)
		port map (
			clk => clk_externo,
			data => data_stack,
			we => write_stack_signal,
			le => load_stack_signal,
			out1 => out_stack1,
			out2 => out_stack2
	);

	myUla: ULA
		generic map (
			DATA_WIDTH => DATA_WIDTH_EXT
		)
		port map (
			clk => clk_externo,
			op	=> op_ula_signal,
			op1 => out_stack1,
			op2 => out_stack2,
			outOP	=> out_ula,
			greater_then => gt_signal,
			less_then => lt_signal,
			equal	=> eq_signal,
			aa => a,
			bb => b
	);

	to_convert1 <= to_integer(unsigned(var_address));

	variables: VAR
		generic map (
			DATA_WIDTH => DATA_WIDTH_EXT,
			ADDR_WIDTH => ADDR_VAR_WIDTH_EXT
		)
		port map (
			clk => clk_externo,
			addr => to_convert1,
			data => out_stack2,
			we	=> write_var_signal,
			q => out_var
	);

	calc_branch: BRANCH
		generic map (
			DATA_WIDTH => DATA_WIDTH_EXT,
			ADDR_WIDTH => ADDR_WIDTH_EXT
		)
		port map (
			clk => clk_externo,
			branch_in1 => out_ram,
			branch_in2 => out_ram1,
			selec_in => load_branch_signal,
			opBranch => op_branch_signal,
			outAddr => jmp_address_signal
	);

	-- muliplexador para dado de entrada da pilha
	process (data_stack_from_signal,out_ula,out_var,branch_controle,out_ram1)
	begin
		if (data_stack_from_signal = "10") then
			data_stack <= out_ula;
		elsif (data_stack_from_signal = "11") then
			data_stack <= out_var;
		elsif (data_stack_from_signal(0) = '1') then
			data_stack <= branch_controle;
		else
			data_stack <= out_ram1;
		end if;
	end process;

	-- muliplexador para endereço da cache de dados
	process (var_address_signal,out_ram1,branch_controle)
	begin
		if (var_address_signal = '1') then
			var_address <= std_logic_vector(resize(unsigned(branch_controle),ADDR_VAR_WIDTH_EXT));
		else
			var_address <= std_logic_vector(resize(unsigned(out_ram1),ADDR_VAR_WIDTH_EXT));
		end if;
	end process;
end rtl;
