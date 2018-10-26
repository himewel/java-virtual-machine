-- Quartus II VHDL Template
-- Single port RAM with single read/write address

library ieee;
use ieee.std_logic_1164.all;

entity STACK is
	generic (
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 5
	);
	port (
		clk		: in std_logic;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic;
		le		: in std_logic_vector(1 downto 0);
		out1		: out std_logic_vector((DATA_WIDTH -1) downto 0);
		out2		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of STACK is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM signal.
	signal ram : memory_t;

	-- Register to hold the address
	signal top_of_stack : natural range 0 to 2**ADDR_WIDTH-1;
	
	signal saida1: std_logic_vector((DATA_WIDTH -1) downto 0);
	signal saida2: std_logic_vector((DATA_WIDTH -1) downto 0);
begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		if(we = '1') then
			ram(top_of_stack) <= data;
			top_of_stack <= top_of_stack + 1;
		end if;
		if (le(1) = '1') then
			if (le(0) = '0') then
				top_of_stack <= top_of_stack - 1;
			elsif (le(0) = '1') then
				top_of_stack <= top_of_stack - 2;
			end if;
		end if;
		saida1 <= ram(top_of_stack-2);
		saida2 <= ram(top_of_stack-1);
	end if;
	end process;
	
	out1 <= saida1;
	out2 <= saida2;

end rtl;
